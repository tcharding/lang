CC = gcc
CFLAGS = -Wall -pedantic -std=c99 -g

OBJ = client.o store.o main.o
RUN = client

.PHONY: clean
default: main

test:
	make clean
	make main
	make tst-store

tst-store: tst-store.o store.o
	$(CC) -o tst-store tst-store.o store.o

main: $(OBJ) 
	$(CC) -o $(RUN) $(OBJ)

%.o: %.c client.h
	$(CC) $(CFLAGS) -c $< 

clean:
	rm -f *.o $(RUN) tst-store
