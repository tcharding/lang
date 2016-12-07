#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string.h>

enum {
    SERVER_PORT = 5319,
    MAX_LINE = 256
};

int main (int argc, char *argv[])
{
/*    FILE *fp; */
    struct hostent *hp;
    struct sockaddr_in sin;
    char *host = "eros";
    char buf[MAX_LINE];
    int s;
    int len;

/*
    if (argc == 2) {
	host = argv[1];
    } else {
	host = 'eros';
	fprintf(stderr, "usage: simplex-talk host\n");
	exit(1); 
    }
    */

    /* translate host name into peer's IP address */
    hp = gethostbyname(host);
    if (!hp) {
	fprintf(stderr, "simplex-talk: unknown host: %s\n", host);
	exit(1);
    }

    /* build address data structure */
    memset(&sin, 0, sizeof(sin)); /*  */
    sin.sin_family = AF_INET;
    memmove(&sin.sin_addr, hp->h_addr, hp->h_length);
    sin.sin_port = htons(SERVER_PORT);
    
    /* active open */
    if ((s= socket(PF_INET, SOCK_STREAM, 0)) < 0) {
	perror("simplex-talk: socket");
	exit(1);
    }
    if (connect(s, (struct sockaddr *)&sin, sizeof(sin)) < 0) {
	perror("simplex-talk: connect");
	close(s);
	exit(1);
    }

    /* main loop: get and send lines of text */
    while (fgets(buf, sizeof(buf), stdin)) {
	buf[MAX_LINE-1] = '\0';
	len = strlen(buf) + 1;
	send(s, buf, len, 0);
    }
}
  
