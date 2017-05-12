#include <iostream>
#include <string>
#include <complex>
#include <thrust/complex.h>
#include <stdio.h>
#include <assert.h>

class CUDAOffloader{

    public:

        CUDAOffloader();
        void getDeviceProperties();
        void add(int& test,int a,int b);

        double sendDataToDeviceAndCompute();

    private:

        int threadsPerBlock,blocksPerGrid;

       //cudaDeviceProp prop;
       //void addCUDA( int *a, int *b, int *c );

};


__device__ __host__ double normC(thrust::complex<double>& c);
