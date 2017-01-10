#include "CUDAfunc.h"

__global__ void addCUDA( int *a, int *b, int *c ){

    *c = *a + *b;


}

void CUDAOffloader::getDeviceProperties(){



    return;

}

void CUDAOffloader::add(int& c,int a,int b){

    int *dev_a, *dev_b, *dev_c;

    cudaMalloc( (void**)&dev_a,sizeof(int) );
    cudaMalloc( (void**)&dev_b,sizeof(int) );
    cudaMalloc( (void**)&dev_c,sizeof(int) );

    cudaMemcpy(dev_a,&a,sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,&b,sizeof(int),cudaMemcpyHostToDevice);

    addCUDA<<<1,1>>>( dev_a, dev_b, dev_c );

    cudaMemcpy( &c, dev_c, sizeof(int), cudaMemcpyDeviceToHost  );

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);

    return;

}


CUDAOffloader::CUDAOffloader(){


}
