CC = gcc
CFLAGS = -Wall -pedantic -std=c99 -g

INCLUDES = -I../include
LFLAGS = -L../lib
LIBS = -lerr

# INCULDES = -I../home/tobin/include
# LIBS = -L/home/tobin/lib

CLI_SRCS = daytimetcpcli.c
CLI_OBJS = $(CLI_SRCS:.c=.o)
CLI = daytimetcpcli

SRV = daytimetcpsrv
SRV_SRCS = daytimetcpsrv.c
SRV_OBJS = $(SRV_SRCS:.c=.o)

.PHONY: depend clean

all:	client server

client: $(CLI_OBJS) 
	$(CC) $(CFLAGS) $(INCLUDES) -o $(CLI) $(CLI_OBJS) $(LFLAGS) $(LIBS)

server: $(SRV_OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) -o $(SRV) $(SRV_OBJS) $(LFLAGS) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< 

clean:
	$(RM) *.o *~ $(MAIN)

depend: $(SRCS)
	makedepend $(INCLUDES) $^

# DO NOT DELETE THIS LINE -- make depend needs it
