/*
 * Scull - memory based character module
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" for more details.
 *
 * Linux Device Drivers by Alessandro Rubini and Jonathan Corbet, 
 * published by O'Reilly & Associates
 */

/*
 * This file contains macros and data types for communication with the
 * scull device driver
 */

#ifndef _LGNT_SCULL_H
#define _LGNT_SCULL_H

/*
#include <linux/fs.h>
#include <linux/semaphore.h>
#include <linux/cdev.h>
*/

#ifndef SCULL_MAJOR
#define SCULL_MAJOR 0   /* dynamic major by default */
#endif

#ifndef SCULL_NR_DEVS
#define SCULL_NR_DEVS 4    /* scull0 through scull3 */
#endif
 
/*
 * The bare device is a variable-length region of memory.
 * Use a linked list of indirect blocks.
 *
 * "scull_dev->data" points to an array of pointers, each
 * pointer refers to a memory area of SCULL_QUANTUM bytes.
 *
 * The array (quantum-set) is SCULL_QSET long.
 */
#ifndef SCULL_QUANTUM
#define SCULL_QUANTUM 4000
#endif

#ifndef SCULL_QSET
#define SCULL_QSET    1000
#endif

/*
 * Representation of scull quantum sets.
 */
struct scull_qset {
	void **data;
	struct scull_qset *next;
};

struct scull_dev {
    struct scull_qset *data; /* Pointer to first quantum */
    int quantum;	     /* The current quantum size */
    int qset;		     /* The current array sive */
    unsigned long size;	     /* Amount of data stored here */
    unsigned int access_key; /* Used by sculluid and sucllpriv */
    struct semaphore sem;    /* Mutual exclusion semaphore */
    struct cdev cdev;	     /* Char device structure */
};

/*
 * The different configurable parameters
 */
extern int scull_major;     /* scull.c */
extern int scull_nr_devs;
extern int scull_quantum;
extern int scull_qset;

/*
 * Prototypes for shared functions
 */
int scull_open(struct inode *inode, struct file *filp);
int scull_release(struct inode *inode, struct file *filp);

ssize_t scull_read(struct file *filp, char __user *buf, \
		   size_t count, loff_t *f_pos);
ssize_t scull_write(struct file *filp, const char __user *buf, \
		    size_t count, loff_t *f_pos);

ssize_t (*readv) (struct file *filp, const struct iovec *iov, \
		  unsigned long count, loff_t *ppos);
ssize_t (*writev) (struct file *filp, const struct iovec *iov, \
		  unsigned long count, loff_t *ppos);

/* still to implement */
loff_t scull_llseek(struct file *filp, loff_t off, int whence);
long scull_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);


/*

**********
Copied from net
*********

int scull_access_init(dev_t dev);
void scull_access_cleanup(void);



loff_t  scull_llseek(struct file *filp, loff_t off, int whence);
long    scull_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
*/

/* file operation prototypes 
loff_t (*scull_llseek) (struct file *filp, loff_t, int);
int (*scull_open)(struct inode *inode, struct file *filp);
int (*scull_release)(struct inode *inode, struct file *filp);
ssize_t (*scull_read)(struct file *filp, const char __user *buf, size_t count, loff_t *f_pos);
ssize_t (*scull_write)(struct file *filp, const char __user *buf, size_t count, loff_t *f_pos);
int (*scull_ioctl)(struct inode *inode, struct file *filp, unsigned int, unsigned long);

struct file_operations scull_fops = {
    .owner = THIS_MODULE,
    .llseek = scull_llseek,
    .read = scull_read,
    .write = scull_write,
    .ioctl = scull_ioctl,
    .open = scull_open,
    .release = scull_release,
};

*/
 



#endif /* _LGNT_SCULL_H */
