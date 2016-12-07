CC = gcc
CFLAGS = -Wall -pedantic -std=c99 -g

OBJ = client.o
EXE = test

.PHONY: clean
default: main

main: $(OBJ) 
	$(CC) -o $(EXE) $(OBJ)

%.o: %.c 
	$(CC) $(CFLAGS) -c $< 

clean:
	rm -f *.o $(EXE)
