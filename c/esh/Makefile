CC = gcc
CFLAGS = -Wall -pedantic -std=c99 -g
LIBS = -lcheck

OBJ = init.o hlpr.o stmnt.o # esh object files excludeing main.c
CHCK = check_init.o check_hlpr.o check_stmnt.o # test suite object files

MAIN = main.o # esh object file containing main() 
TEST = test_suite.o # test suite object file containing main() 

.PHONY: test clean
default: test

test:
	make clean
	make esh
	make suite

suite: $(CHCK) $(OBJ) $(TEST)
	$(CC) -o test-suite $(OBJ) $(CHCK) $(TEST) $(LIBS)

esh: $(OBJ) $(MAIN) esh.h
	$(CC) -o esh $(OBJ) $(MAIN)

%.o: %.c esh.h
	$(CC) $(CFLAGS) -c $< 

clean:
	rm -f *.o esh test-suite $(TEST) $(MAIN)
