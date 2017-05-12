CC = g++
CFLAGS = -O3
LFLAGS = -O3
OBS = main.o

CUDAPractice: $(OBS)
	$(CC) $(LFLAGS) $(OBS) -o CUDAPractice

main.o: main.cpp
	$(CC) $(CFLAGS) -c main.cpp

clean:
	rm *.o CUDAPractice
