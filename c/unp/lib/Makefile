CC = gcc
RANLIB = ranlib
RM = rm 

CFLAGS = -Wall -pedantic -std=c99
INC = -I../include

# Attribution: Advanced Programming in the UNIX Environment 
#   - W. Richard Stevens, 3rd edition
LIB_SRCS = \
	sock_ntop.c \
	sock_bind_wild.c \
	sock_cmp_addr.c \
	sock_cmp_port.c \
	sock_get_port.c \
	sock_ntop_host.c \
	sock_set_addr.c \
	sock_set_port.c \
	sock_set_wild.c \

LIB_OBJS = $(LIB_SRCS:.c=.o)
LIB_NAME = libsock.a

.PHONY: all

all: clean $(LIB_NAME)
	@echo Compiled library: $(LIB_NAME)

$(LIB_NAME):	${LIB_OBJS}
		ar ruv ${LIB_NAME} $?
		${RANLIB} ${LIB_NAME}

%.o: %.c
	$(CC) $(CFLAGS) -c $< $(INC)

clean:
	$(RM) -f *.o *~ $(LIB_NAME)

