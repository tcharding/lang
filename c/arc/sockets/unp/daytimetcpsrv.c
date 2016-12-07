#include "socket.h"
#include <time.h>

int
main(int argc, char *arg[])
{
    int listenfd, connfd;
    struct sockaddr_in servaddr;
    char buf[MAXLINE];
    time_t ticks;

    if ( (listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	err_sys("socket error");

    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port = htons(13); /* daytime server */
    
    if ( (bind(listenfd, (SA *) &servaddr, sizeof(servaddr))) < 0)
	err_sys("bind error");

    if ( (listen(listenfd, LISTENQ)) < 0)
	err_sys("listen error");

    for ( ; ; ) {
	if ( (connfd = accept(listenfd, (SA *) NULL, NULL)) < 0)
	    err_sys("accept error");

	ticks = time(NULL);
	snprintf(buf, sizeof(buf), "%.24s\r\n", ctime(&ticks));
	if (write(connfd, buf, strlen(buf)) < 0 )
	    err_ret("write error");

	if (close(connfd) > 0)
	    err_ret("close error");
    }
}
