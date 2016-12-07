#include "socket.h"
#include "err.h"

/* 
 * sock_ntop: convert IPv4 on IPv6 address from binary to text form 
 * returns static memory 
 */
char *
sock_ntop(const struct sockaddr *sa, socklen_t salen)
{
    char portstr[8];
    static char str[128];

    switch (sa->sa_family) {
    case AF_INET:{
	struct sockaddr_in *sin = (struct sockaddr_in *) sa;

	if (inet_ntop(AF_INET, &sin->sin_addr, str, sizeof(str)) == NULL)
	    return (NULL);
	if (ntohs(sin->sin_port) != 0) {
	    snprintf(portstr, sizeof(portstr), ":%d", ntohs(sin->sin_port));
	    strcat(str, portstr);
	}
	return (str);
    }
/* end sock_ntop */
#ifdef	IPV6
    case AF_INET6: {
	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *) sa;

	str[0] = '[';
	if (inet_ntop(AF_INET6, &sin6->sin6_addr, str + 1, sizeof(str) - 1) == NULL)
	    err_sys("sock_ntop error");
	if (ntohs(sin6->sin6_port) != 0) {
	    snprintf(portstr, sizeof(portstr), "]:%d", ntohs(sin6->sin6_port));
	    strcat(str, portstr);
	    return(str);
	}
	return (str + 1);
    }
#endif
    default:
	snprintf(str, sizeof(str), "sock_ntop: unknown AF_xxx: %d, len %d",
		 sa->sa_family, salen);
	return(str);
    }
    return (NULL);
}
