#include "socket.h"
#include "err.h"
#include <errno.h>

int main (int argc, char *argv[])
{
    int sockfd, n;
    char recvline[MAXLINE + 1];
    struct sockaddr_in servaddr;
    int cnt = 0;		/* read counter */

    if (argc != 2) 
	err_quit("usage: %s <IPaddress>", argv[0]);
    
    if ( (sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	err_sys("socket error, (errno: %d)\n", errno);

    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(13); /* daytime server */
    if (inet_pton(AF_INET, argv[1], &servaddr.sin_addr) <= 0)
	err_quit("inet_pton error fo %s\n", argv[1]);

    if (connect(sockfd, (struct sockaddr *) &servaddr, sizeof(struct sockaddr)) < 0)
	err_sys("connect error");

    while ( (n = read(sockfd, recvline, MAXLINE)) > 0) {
	cnt++;
	recvline[n] = '\0';
	if (fputs(recvline, stdout) == EOF)
	    err_sys("fputs error");
	printf("cnt: %d\n", cnt);
    }
    if (n < 0)
	err_sys("read error");

    exit(EXIT_SUCCESS);
}
