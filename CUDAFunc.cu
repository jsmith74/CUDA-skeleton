#include "CUDAfunc.h"

#define BLOCKS_PER_GRID 350

#define THREADS_PER_BLOCK 1024

__device__ bool next_permutation(int* __first, int* __last);
__device__ void reverse(int* __first, int* __last);
__device__ inline double cNorm(thrust::complex<double>& c);
__device__ inline void iter_swap(int* __a, int* __b);

__global__ void reduce(thrust::complex<double> *Udev,double result[]){

    double output = 0.0;
    int k = 0;

    int cacheIndex = threadIdx.x;

    __shared__ double cache[THREADS_PER_BLOCK];

    int i[10];

    for(int j=0;j<10;j++) i[j] = j;

    do{

        output += cNorm(Udev[ k % 10 ]);
        output -= cNorm(Udev[ k % 10 ]);
        k++;

    } while(next_permutation( i,i+10) );

    cache[cacheIndex] = output;

    __syncthreads();

    int ii = blockDim.x/2;

    while(ii != 0){

        if(cacheIndex < ii){

            cache[cacheIndex] += cache[cacheIndex + ii];

        }

        __syncthreads();

        ii /= 2;

    }

    if(cacheIndex == 0) result[blockIdx.x] = cache[0];

}

CUDAOffloader::CUDAOffloader(){

}

double CUDAOffloader::sendDataandCompute(thrust::complex<double> U[]){

    thrust::complex<double> *Udev;

    double *resultDev;
    double *result;

    cudaMalloc( (void**)&Udev, 10 * sizeof(thrust::complex<double>) );

    cudaMalloc( (void**)&resultDev, BLOCKS_PER_GRID*sizeof(double) );

    cudaMemcpy( Udev, U, 10*sizeof(thrust::complex<double>), cudaMemcpyHostToDevice );

    reduce<<<BLOCKS_PER_GRID,THREADS_PER_BLOCK>>>(Udev, resultDev);

    result = (double*)malloc( BLOCKS_PER_GRID * sizeof(double) );

    cudaMemcpy( result, resultDev, BLOCKS_PER_GRID*sizeof(double), cudaMemcpyDeviceToHost );

    double output = 0.0;

    for(int i=0;i<BLOCKS_PER_GRID;i++){

        output += result[i];

    }

    cudaFree( Udev );

    cudaFree( resultDev );

    free( result );

    return output;

}

__device__ inline double cNorm(thrust::complex<double>& c){

    return c.real() * c.real() + c.imag() * c.imag();

}

__device__ inline void iter_swap(int* __a, int* __b) {
  int __tmp = *__a;
  *__a = *__b;
  *__b = __tmp;
}

__device__ void reverse(int* __first, int* __last) {

  while (true)
    if (__first == __last || __first == --__last)
      return;
    else{
      iter_swap(__first++, __last);
    }
}

__device__ bool next_permutation(int* __first, int* __last) {

  if (__first == __last)
    return false;
  int* __i = __first;
  ++__i;
  if (__i == __last)
    return false;
  __i = __last;
  --__i;

  for(;;) {
    int* __ii = __i;
    --__i;
    if (*__i < *__ii) {
      int* __j = __last;
      while (!(*__i < *--__j))
        {}
    iter_swap(__i, __j);
      reverse(__ii, __last);
      return true;
    }
    if (__i == __first) {
      reverse(__first, __last);
      return false;
    }
  }

}
