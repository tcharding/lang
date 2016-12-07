#include <linux/init.h>
#include <linux/module.h>
MODULE_LICENSE("Dual BSD/GPL");
/* 
 * Hello World - first kernel module
 *
 * Author: Tobin Harding
 *
 * Acknowledge: "Linux Device Drivers, Third edition, by
 * Jonathon Corbet, Alessandro Rubini, and Greg Kroah-Hartman.
 * Copyright 2005 O'Rielly Media, Inc., 0-596-00590-3."
 */
static char *whom  = "world";
module_param(whom, charp, S_IRUGO);

static int hello_init(void)
{
    printk(KERN_ALERT "Hello, %s\n", whom);
    return 0;
}

static void hello_exit(void)
{
  printk(KERN_ALERT "Goodbye, cruel world\n");
}

module_init(hello_init);
module_exit(hello_exit);
