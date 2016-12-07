/*
 * scull.c - the bare scull character module
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" for more details.
 *
 * Linux Device Drivers by Alessandro Rubini and Jonathan Corbet, 
 * published by O'Reilly & Associates
 */
#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>

#include <linux/kernel.h>	/* printk() */
#include <linux/fs.h>		/* everything... */
#include <linux/types.h>	/* size_t */
#include <linux/errno.h>	/* error codes */
#include <linux/cdev.h>		/* cdev */
#include <linux/slab.h>		/* kmalloc, kfree */
#include <asm/uaccess.h>	/* copy_to_user */

#include "scull.h"		/* local definitions */

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Tobin Harding <tharding@lgnt.com.au>");
MODULE_DESCRIPTION("Scull - character device implemented in memory");
MODULE_VERSION("0.1");

/\* Prototypes */
void scull_setup_cdev(struct scull_dev *dev, int index);
int scull_trim(struct scull_dev *dev);
struct scull_qset *scull_follow(struct scull_dev *dev, int n);

/*
 * Our parameters which can be set at load time.
 */

int scull_major =   SCULL_MAJOR;
int scull_nr_devs = SCULL_NR_DEVS;	/* number of bare scull devices */
int scull_quantum = SCULL_QUANTUM;
int scull_qset =    SCULL_QSET;
int scull_minor =   0;

module_param(scull_major, int, S_IRUGO);
module_param(scull_minor, int, S_IRUGO);
module_param(scull_nr_devs, int, S_IRUGO);
module_param(scull_quantum, int, S_IRUGO);
module_param(scull_qset, int, S_IRUGO);

struct scull_dev *scull_devices;	/* allocated in scull_init_module */


/* 
 * scull file operations
 */
struct file_operations scull_fops = {
    .owner = THIS_MODULE,
/*    .llseek = scull_llseek, */
    .read = scull_read,
    .write = scull_write,
/*    .ioctl = scull_ioctl, */
    .open = scull_open,
    .release = scull_release,
};

/* still to implement */
loff_t  scull_llseek(struct file *filp, loff_t off, int whence)
{
    return 0;
}
long scull_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    return 0;
}

/*
 *
 */
int scull_open(struct inode *inode, struct file *filp)
{
    struct scull_dev *dev;   /* device inormation */

printk(KERN_NOTICE "SCULL_DEBUG scull_open called");

    dev = container_of(inode->i_cdev, struct scull_dev, cdev);
    filp->private_data = dev; /* for other methods */

    /* now trim to 0 the length of the device if open was write-only */
    if ( (filp->f_flags & O_ACCMODE) == O_WRONLY) {
	scull_trim(dev);	/* ignore errors */
    }
    return 0;			/* success */
}
/*
 * Opposite of scull_open()
 */
int scull_release(struct inode *inode, struct file *filp)
{
printk(KERN_NOTICE "SCULL_DEBUG scull_release called");
    return 0;
}

int scull_trim(struct scull_dev *dev)
{
    struct scull_qset *next, *dptr;
    int qset = dev->qset;	/* "dev" is not-null */
    int i;
    
    for (dptr = dev->data; dptr; dptr = next) { /* all the list items */
	if (dptr->data) {
	    for (i = 0; i < qset; i++)
		kfree(dptr->data[i]);
	    kfree(dptr->data);    
	    dptr->data = NULL;
	}
	next = dptr->next;
	kfree(dptr);
    }
    dev->size = 0;
    dev->quantum = scull_quantum;
    dev->qset = scull_qset;
    dev->data = NULL;
    return 0;
}
/*
 * 
 */
ssize_t scull_read(struct file *filp, char __user *buf, \
		   size_t count, loff_t *f_pos)
{
    struct scull_dev *dev = filp->private_data;
    struct scull_qset *dptr;	/* the first listitem */
    int quantum, qset;
    int itemsize;		/* how many bytes in the listitem */
    int item, s_pos, q_pos, rest;
    ssize_t retval = 0;

    printk(KERN_NOTICE "SCULL_DEBUG calling scull_read with count: %d", (int)count);

    if (down_interruptible(&dev->sem))
	return -ERESTARTSYS;
    quantum = dev->quantum;
    qset = dev->qset;
    itemsize = quantum*qset;

    if (*f_pos >= dev->size)
	count = dev->size - *f_pos;

    /* find listitem, qset index, and offset in the quantum */
    item = (long)*f_pos / itemsize;
    rest = (long)*f_pos % itemsize;
    s_pos = rest / quantum;
    q_pos = rest % quantum;

    /* follow the list up to the right position (defined elsewhere) */
    dptr = scull_follow(dev, item);

    if (dptr == NULL || ! dptr->data || ! dptr->data[s_pos])
	goto out; 		/* don't fill holes */
    
    /* read only up to the end of this quantum */
    if (count > quantum - q_pos)
	count = quantum - q_pos;

    if (copy_to_user(buf, dptr->data[s_pos] + q_pos, count)) {
	retval = -EFAULT;
	goto out;
    }
    *f_pos += count;
    retval = count;

out:
    up(&dev->sem);
    return retval;
}
/*
 * 
 */
ssize_t scull_write(struct file *filp, const char __user *buf, \
		    size_t count, loff_t *f_pos)
{
    struct scull_dev *dev = filp->private_data;
    struct scull_qset *dptr;
    int quantum = dev->quantum;
    int qset = dev->qset;
    int itemsize = quantum * qset;
    int item, s_pos, q_pos, rest;
    ssize_t retval = -ENOMEM; /* value used in "goto out" statments */
    
    if (down_interruptible(&dev->sem))
	return -ERESTARTSYS;

    printk(KERN_NOTICE "SCULL_DEBUG calling scull_write with count: %d", (int)count);

    /* find listitem, qset index and offset in the quantum */
    item = (long)*f_pos / itemsize;
    rest = (long)*f_pos % itemsize;
    s_pos = rest / quantum;
    q_pos = rest % quantum;

    /* follow the list up to the right position */
    dptr = scull_follow(dev, item);
    if (dptr == NULL)
	goto out;
    if (!dptr->data) {
	dptr->data = kmalloc(qset * sizeof(char *), GFP_KERNEL);
	if (!dptr->data)
	    goto out;
	memset(dptr->data, 0, qset * sizeof(char *));
    }  
    if (!dptr->data[s_pos]) {
	dptr->data[s_pos] = kmalloc(quantum, GFP_KERNEL);
	if (!dptr->data[s_pos])
	goto out;
    }
    /* write only up to the end of this quantum */
    if (count > quantum - q_pos)
	count = quantum - q_pos;

    if (copy_from_user(dptr->data[s_pos] + q_pos, buf, count)) {
	retval = -EFAULT;
	goto out;
    }
    *f_pos += count;
    retval = count;

    /* update the size */
    if (dev->size < *f_pos)
	dev->size =*f_pos;

out:
    up(&dev->sem);
    return retval;
}
/*
 * ollow the list
 */
struct scull_qset *scull_follow(struct scull_dev *dev, int n)
{
	struct scull_qset *qs = dev->data;

        /* Allocate first qset explicitly if need be */
	if (! qs) {
		qs = dev->data = kmalloc(sizeof(struct scull_qset), GFP_KERNEL);
		if (qs == NULL)
			return NULL;  /* Never mind */
		memset(qs, 0, sizeof(struct scull_qset));
	}

	/* Then follow the list */
	while (n--) {
		if (!qs->next) {
			qs->next = kmalloc(sizeof(struct scull_qset), GFP_KERNEL);
			if (qs->next == NULL)
				return NULL;  /* Never mind */
			memset(qs->next, 0, sizeof(struct scull_qset));
		}
		qs = qs->next;
		continue;
	}
	return qs;
}

/*
 * Finally, the module stuff
 */

/*
 * Initialise cdev and add to system
 */
void scull_setup_cdev(struct scull_dev *dev, int index) 
{
    int err;
    int devno = MKDEV(scull_major, scull_minor + index);

    cdev_init(&dev->cdev, &scull_fops);
    dev->cdev.owner = THIS_MODULE;
    dev->cdev.ops = &scull_fops;
    err = cdev_add (&dev->cdev, devno, 1); 
    /* Fail gracefully if need be */
    if (err)
	printk(KERN_NOTICE "Error %d adding scull%d", err, index);
}

/*
 * The cleanup function is used to handle initialization failures as well.
 * Thefore, it must be careful to work correctly even if some of the items
 * have not been initialized
 */
void scull_cleanup_module(void)
{
	int i;
	dev_t devno = MKDEV(scull_major, scull_minor);

	/* Get rid of our char dev entries */
	if (scull_devices) {
		for (i = 0; i < scull_nr_devs; i++) {
			scull_trim(scull_devices + i);
			cdev_del(&scull_devices[i].cdev);
		}
		kfree(scull_devices);
	}

	/* cleanup_module is never called if registering failed */
	unregister_chrdev_region(devno, scull_nr_devs);
	printk(KERN_ALERT "SCULL_DEBUG: removed scull module\n");

}

/*
 * Scull init function
 */
static int scull_init_module(void)
{
    dev_t dev = 0;
    int result, i;

    /* get scull major device number */
    if (scull_major) {
	dev = MKDEV(scull_major, scull_minor);
	result = register_chrdev_region(dev, scull_nr_devs, "scull");
    } else {
	result = alloc_chrdev_region(&dev, scull_minor, scull_nr_devs, "scull");
	scull_major = MAJOR(dev);
    }
    if (result < 0) {
	printk(KERN_WARNING "scull can't get major %d\n", scull_major);
	return result;
    }

    /* 
     * allocate the devices -- we can't have them static, as the number
     * can be specified at load time
     */
    scull_devices = kmalloc(scull_nr_devs * sizeof(struct scull_dev), GFP_KERNEL);
    if (!scull_devices) {
	result = -ENOMEM;
	goto fail;  /* Make this more graceful */
    }
    memset(scull_devices, 0, scull_nr_devs * sizeof(struct scull_dev));

    /* Initialize each device. */
    for (i = 0; i < scull_nr_devs; i++) {
	scull_devices[i].quantum = scull_quantum;
	scull_devices[i].qset = scull_qset;
	sema_init(&scull_devices[i].sem, 1);
	scull_setup_cdev(&scull_devices[i], i);
    }
	   
	   /* At this point call the init function for any friend device */
    dev = MKDEV(scull_major, scull_minor + scull_nr_devs);
    /*  dev += scull_p_init(dev);
	dev += scull_access_init(dev); */

    printk(KERN_ALERT "SCULL_DEBUG: inserted scull module\n");
    return 0; /* succeed */

    fail:
    scull_cleanup_module();
    return result;
}

module_init(scull_init_module);
module_exit(scull_cleanup_module);
