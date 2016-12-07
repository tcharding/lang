/*
 *  This file is part of libth.
 *
 *  libth is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  libth is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with libth.  If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef _TH_H
#define _TH_H

/*
 * Standard Header - to be included before all standard system headers.
 */

#define _POSIX_C_SOURCE 200809L
#include <stdio.h>		/* for convenience */
#include <stdlib.h>		/* for convenience */
#include <string.h>		/* for convenience */
#include <unistd.h>		/* for convenience */

#include <sys/types.h>		/* basic system data types */
#include <error.h>		/* for perror */
#include <errno.h>
#include <signal.h>
#include <ctype.h>
#include <inttypes.h>
#include <sys/time.h>		/* timeval{} for select */

enum {
    BUFSIZE = 8192,		/* buffer size for reads and writes */
    MAXLINE = 4096		/* max text line length */
};

#define max(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a > _b ? _a : _b; })

#define min(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a < _b ? _a : _b; })

/* Define bzero() as macro */
#define bzero(ptr, n) memset(ptr, 0, (size_t)(n))

/* prototypes for error functions: lib/error.c */
void err_ret(const char *fmt, ...); 
void err_sys(const char *fmt, ...) __attribute__((noreturn));
void err_dump(const char *fmt, ...) __attribute__((noreturn));
void err_msg(const char *fmt, ...);
void err_quit(const char *fmt, ...) __attribute__((noreturn));

/* prototypes for Unix wrapper functions: lib/wrapunix.c */
void *Calloc(size_t, size_t);
void Close(int);
void Dup2(int, int);
int Fcntl(int, int, int);
void Gettimeofday(struct timeval *, void *);
int Ioctl(int, int, void *);
pid_t Fork(void);
void *Malloc(size_t);
int Mkstemp(char *);
void *Mmap(void *, size_t, int, int, int, off_t);
int Open(const char *, int, mode_t);
void Pipe(int *fds);
ssize_t Read(int, void *, size_t);
void Sigaddset(sigset_t *, int);
void Sigdelset(sigset_t *, int);
void Sigemptyset(sigset_t *);
void Sigfillset(sigset_t *);
int Sigismember(const sigset_t *, int);
void Sigpending(sigset_t *);
void Sigprocmask(int, const sigset_t *, sigset_t *);
char *Strdup(const char *);
long Sysconf(int);
void Sysctl(int *, uint32_t, void *, size_t *, void *, size_t);
void Unlink(const char *);
pid_t Wait(int *);
pid_t Waitpid(pid_t, int *, int);
void Write(int, void *, size_t);

/* prototypes for stdio wrapper functions: wrapstio.c */
void Fclose(FILE *);
FILE *Fdopen(int, const char *);
char *Fgets(char *, int, FILE *);
FILE *Fopen(const char *, const char *);
void Fputs(const char *, FILE *);

#endif	/* _TH_H */
