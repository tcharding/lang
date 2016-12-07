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
#include <netinet/in.h>		/* sockaddr_in and other Intrenet definitions */
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
    BUFFSIZE = 8192,		/* buffer size for reads and writes */
    LISTENQ = 1024,		/* second argument to listen() */
    SERV_PORT = 9877,		/* TCP and UDP */
    MAXLINE = 4096,		/* max line size */
};

#define SERV_PORT_STR "9877"	/* TCP and UDP */

/* Define bzero() as macro */
#define bzero(ptr, n) memset(ptr, 0, (size_t)(n))

#define SA struct sockaddr	/* for convenience */

/* function prototypes */

/* All sock_* functions handle sockaddr ptrs in in IPv4 IPv6 independant manner */
char *sock_ntop(const struct sockaddr *sockaddr, socklen_t addrlen); /* returns NULL on error */
int sock_bind_wild(int sockfd, int family); /* returns 0 if OK, -1 on error */
int sock_cmp_addr(const SA *, const SA *, socklen_t addrlen);  /* returns 0 if addresses are same family and equal, else nonzero */
int sock_cmp_port(const SA *, const SA *, socklen_t addrlen); /* returns 0 if addresses are same family and ports are equal, else nonzero */
int sock_get_port(const SA *sockaddr, socklen_t addrlen);	      /* returns non-negative port number for IPv4 or IPv6 address, else -1 */
char *sock_ntop_host(const SA *sockaddr, socklen_t addrlen);	      /* returns NULL on error */
void sock_set_addr(SA *sockaddr, socklen_t addrlen, const void *ptr); 
void sock_set_port(SA *sockaddr, socklen_t addrlen, const int port);
void sock_set_wild(SA *sockaddr, socklen_t addrlen);

#endif	/* _SOCKET_H */
