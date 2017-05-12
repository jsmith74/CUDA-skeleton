#include <iostream>
#include <ctime>
#include <iomanip>

#include "CUDAfunc.h"
#include "BootLegPermutation.h"

template <class cc>
void printArr(cc i[]){

    for(int j=0;j<10;j++) std::cout << i[j] << " ";
    std::cout << std::endl;

}

inline double cNormTest(thrust::complex<double>& c){

    return c.real() * c.real() + c.imag() * c.imag();

}

int main(){

    clock_t t1,t2;

    t1 = clock();

    CUDAOffloader OffloadToGPU;

    thrust::complex<double> U[10];

    thrust::complex<double> I(0.0,1.0);

    for(int i=0;i<10;i++) U[i] = 0.1*i + 0.15*i*I;

    double output = OffloadToGPU.sendDataandCompute(U);

    t2 = clock();

    float diff = (float)t2 - (float)t1;

    std::cout << "Result: " << output << std::endl;
    std::cout << "Time Elapsed: " << diff / CLOCKS_PER_SEC << std::endl;

    int i[10];

    t1 = clock();

    BootLegPermutation CPU_Alg;

    for(int j=0;j<10;j++) i[j] = j;

    int k=0;

    output = 0.0;

    for(int j=0;j<350*1024;j++){

        k = 0;

        do{

            output += cNormTest(U[ k % 10 ]);
            output -= cNormTest(U[ k % 10 ]);
            k++;

        } while(CPU_Alg.next_permutation( i,i+10) );

        //printArr(i);

    }

    t2 = clock();

    std::cout << "Num Permutations: " << k << std::endl;

    diff = (float)t2 - (float)t1;

    std::cout << "Result: " << output << std::endl;
    std::cout << "Time Elapsed: " << diff / CLOCKS_PER_SEC << std::endl;

    return 0;

}

