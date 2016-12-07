CC = gcc
CFLAGS = -Wall -pedantic -std=c99 -g

default: suite

suite:
	make clean
	make client
	make tst-verbrose
	make tst-client

client: store.o client.o main.o
	$(CC) -o $@ $^

tst-verbrose: tst-verbrose.o store.o client.o
	$(CC) -o $@ $^

tst-client: tst-client.o store.o client.o
	$(CC) -o $@ $^

%.o: %.c client.h
	$(CC) $(CFLAGS) -c $<

.PHONY: clean

clean:
	rm -f *.o tst-verbrose client
