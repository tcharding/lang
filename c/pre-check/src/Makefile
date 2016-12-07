# define the C compiler to use
CC = gcc

# include directory
IDIR = ../include

# define any compile-time flags
CFLAGS = -Wall -pedantic -std=c99 -g -I$(IDIR)


#  source files
#
SRC = init.c parse.c stmnt.c hlpr.c # core
TSRC = tst-init.c  tst-parse.c  tst-stmnt.c tst-hlpr.c # tests
EMSRC = main.c # esh main
TMSRC = tst.c # test suite main

# define the C object files 
OBJ = $(SRC:.c=.o) 
TOBJ = $(TSRC:.c=.o) 

# define the executable file 
MAIN = esh
TEST = tst-suite

# Build Rules

all: esh test

test: $(OBJ) $(TOBJ) $(TMSRC:.c=.o)
	$(CC) -o test-suite  $(OBJ) $(TOBJ) $(TMSRC:.c=.o)

esh: $(OBJ) $(EMSRC:.c=.o)
	$(CC) -o esh $(OBJ) $(EMSRC:.c=.o)
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< 

clean:
	rm *.o esh test-suite
