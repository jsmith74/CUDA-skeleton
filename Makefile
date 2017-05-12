CC = g++
CUCC = nvcc
CFLAGS = -c -O3 -funroll-loops
CUFLAGS = -c
LFLAGS = 
OBS = main.o CUDAFunc.o BootLegPermutation.o

all: CUDAEXE

CUDAEXE: $(OBS)
	$(CUCC) $(LFLAGS) $(OBS) -o CUDAEXE

CUDAFunc.o: CUDAFunc.cu
	$(CUCC) $(CUFLAGS) CUDAFunc.cu

BootLegPermutation.o: BootLegPermutation.cpp
	$(CC) $(CFLAGS) BootLegPermutation.cpp

main.o: main.cpp
	$(CC) $(CFLAGS)  main.cpp

clean:
	rm *.o CUDAEXE
