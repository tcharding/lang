/*
 * Standard Header - to be included before all standard system headers.
 * 
 * based on: Advanced Programming in the UNIX Environment by W. R. Stevens
 */
#ifndef _LGNT_H
#define _LGNT_H

#define _POSIX_C_SOURCE 200809L

#if defined(SOLARIS)		/* Solaris 10 */
#define _XOPEN_SOURCE 600
#else
#define _XOPEN_SOURCE 700
#endif

#include <stdio.h>		/* for convenience */
#include <stdlib.h>		/* for convenience */
#include <string.h>		/* for convenience */
#include <unistd.h>		/* for convenience */

#ifndef _ERR_H
#define _ERR_H

enum {
	MAXLINE	= 4096			/* max line length */    
}

void	err_ret(const char *, ...); /* Nonfatal (system call) */
void	err_sys(const char *, ...) __attribute__((noreturn)); /* Fatal */
void	err_dump(const char *, ...) __attribute__((noreturn)); /* Fatal */

void	err_msg(const char *, ...); /* Nonfatal */
void	err_cont(int, const char *, ...); /* Nonfatal */
void	err_quit(const char *, ...) __attribute__((noreturn)); /* Fatal */
void	err_exit(int, const char *, ...) __attribute__((noreturn)); /* Fatal */

#endif	/* _LGNT_H */
