#include "socket.h"
#include "err.h"

/* readn: Read "n" bytes from a descriptor. */
ssize_t			       
readn(int fd, void *vptr, size_t n)
{
    size_t	nleft;
    ssize_t	nread;
    char	*ptr;

    ptr = vptr;
    nleft = n;
    while (nleft > 0) {
	if ( (nread = read(fd, ptr, nleft)) < 0) {
	    if (errno == EINTR)
		nread = 0;	/* and call read() again */
	    else
		err_sys("readn error");
	} else if (nread == 0)
	    break;		/* EOF */

	nleft -= nread;
	ptr   += nread;
    }
    return(n - nleft);		/* return >= 0 */
}
