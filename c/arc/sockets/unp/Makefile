CC = gcc
CFLAGS = -Wall -pedantic -std=c99 -g

INCULDES = -I../include
LFLAGS = -L../lib
# INCULDES = -I../home/tobin/include
# LIBS = -L/home/tobin/lib

SRCS =
OBJS = $(SRCS:.c=.o)
MAIN =

HEADERS = 

.PHONY: depend clean

all:	$(MAIN)
	@echo ... has been compiled

$(MAIN): $(OBJS) 
        $(CC) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) $(LFLAGS) $(LIBS)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< 

clean:
        $(RM) *.o *~ $(MAIN)

depend: $(SRCS)
        makedepend $(INCLUDES) $^

# DO NOT DELETE THIS LINE -- make depend needs it
