CUDAExe: CUDAfunc.o main.o
	nvcc CUDAfunc.o main.o -o CUDAExe

main.o: main.cpp
	g++ -c main.cpp

CUDAfunc.o: CUDAfunc.cu
	nvcc -c CUDAfunc.cu

clean:
	rm CUDAExe *.o
