/*
 * Standard Header - to be included before all standard system headers.
 *
 * Socket Version
 * 
 * based on: UNIX Network Programming Volume 1, W. R. Stevens
 */
#ifndef _SOCKET_H
#define _SOCKET_H

#define _POSIX_C_SOURCE 200809L

#if defined(SOLARIS)		/* Solaris 10 */
#define _XOPEN_SOURCE 600
#else
#define _XOPEN_SOURCE 700
#endif

#include <sys/types.h>		/* basic system data types */
#include <sys/socket.h>		/* basic socket definitions */
#include <error.h>		/* for perror */
#include <netdb.h>
#include <netinet/in.h>		/* sockaddr_in and other Intrenet defns */
#include <arpa/inet.h>
#include <stdio.h>		/* for convenience */
#include <stdlib.h>		/* for convenience */
#include <string.h>		/* for convenience */
#include <unistd.h>		/* for convenience */

/* #include <signal.h> */
/* #include <sys/un.h>		/\* for Unix domain sockets *\/ */
/* #include <fcntl.h>		/\* for non-blocking *\/ */
/* #include <sys/time.h>		/\* timeval{} for select *\/ */
/* #include <time.h>		/\* timespec{} for pselect *\/ */
/* #include <arpa/inet.h>		/\* inet {3} functions *\/ */

enum {
    MAXLINE = 4096,		/* max line length */    
    BUFFSIZE = 8192,		/* buffer size for reads and writes */
    LISTENQ = 1024,		/* second argument to listen() */
    SERV_PORT = 9877		/* TCP and UDP */
};

#define SERV_PORT_STR "9877"	/* TCP and UDP */

/* Define bzero() as macro */
#define bzero(ptr, n) memset(ptr, 0, (size_t)(n))

#define SA struct sockaddr	/* for convinience */

/* error funtion prototypes */
void	err_ret(const char *, ...); /* Nonfatal (system call) */
void	err_sys(const char *, ...) __attribute__((noreturn)); /* Fatal */
void	err_dump(const char *, ...) __attribute__((noreturn)); /* Fatal */

void	err_msg(const char *, ...); /* Nonfatal */
void	err_cont(int, const char *, ...); /* Nonfatal */
void	err_quit(const char *, ...) __attribute__((noreturn)); /* Fatal */
void	err_exit(int, const char *, ...) __attribute__((noreturn)); /* Fatal */

#endif	/* _SOCKET_H */
