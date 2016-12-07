/*
 * Standard Header - to be included before all standard system headers.
 *
 * Error Code Version
 * 
 * Attribution: UNIX Network Programming Volume 1, W. R. Stevens
 */
#ifndef _ERROR_H
#define _ERROR_H

#define _POSIX_C_SOURCE 200809L

#include <stdio.h>				/* for convenience */				
#include <stdlib.h>			
#include <stdarg.h>	
#include <string.h>			
#include <unistd.h>			
#include <errno.h>
#include <sys/types.h>
#include <signal.h>
#include <inttypes.h>

enum {
    BUFFSIZE = 8192,		/* buffer size for reads and writes */
	MAXLINE = 4096
};

/* Define bzero() as macro */
#define bzero(ptr, n) memset(ptr, 0, (size_t)(n))

/* error funtion prototypes */
void err_ret(const char *fmt, ...); 
void err_sys(const char *fmt, ...) __attribute__((noreturn));
void err_dump(const char *fmt, ...) __attribute__((noreturn));
void err_msg(const char *fmt, ...); 
void err_cont(int error, const char *fmt, ...);
void err_quit(const char *fmt, ...) __attribute__((noreturn));

#endif	/* _ERROR_H */
