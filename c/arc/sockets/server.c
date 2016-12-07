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
    MAX_PENDING = 5,
    MAX_LINE = 256
};

int main (void)
{
    struct sockaddr_in sin;
    char buf[MAX_LINE];
    socklen_t len;
    int s, new_s;

    /* build address data structure */
    memset(&sin, 0, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = INADDR_ANY;
    sin.sin_port = htons(SERVER_PORT);

    /* setup passive open */
    if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
	perror("simplex-talk: socket");
	exit(1);
    }
    if ((bind(s, (struct sockaddr *)&sin, sizeof(sin))) < 0) {
	perror("simplex-talk: bind");
	exit(1);
    }
    listen(s, MAX_PENDING);

    /* wait for connection, then receive and print text */
    for(;;) {
	if ((new_s = accept(s, (struct sockaddr *)&sin, &len)) < 0) {
	    perror("simplex-talk: accept");
	    exit(1);
	}
	while ((len = recv(new_s, buf, sizeof(buf), 0)))
	    fputs(buf, stdout);
	close(new_s);
    }
}
