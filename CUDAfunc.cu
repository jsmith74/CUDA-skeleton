#include "CUDAfunc.h"

#define BLOCKS_PER_GRID 350

#define THREADS_PER_BLOCK 1024

__global__ void addCUDA( int *a, int *b, int *c ){

    *c = *a + *b;


}

__device__ __host__ double normC(thrust::complex<double>& c){

    return c.real() * c.real() + c.imag() * c.imag();

}

__global__ void dot(thrust::complex<double> *c,double *result){

//    if(threadIdx.x==0 && blockIdx.x==0){
//
//        for(int i=0;i<10;i++) printf("%d\t%d\n",c[i].real(),c[i].imag());
//
//        //assert(1>2);
//
//    }

    __shared__ double cache[THREADS_PER_BLOCK];

    int cacheIndex = threadIdx.x;

    double temp = 0.0;

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp += normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp -= normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp += normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp -= normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp += normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp -= normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp += normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp -= normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp += normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp -= normC( c[j] );

    for(int k=0;k<100;k++) for(int j=0;j<10;j++) temp += normC( c[j] );

    cache[cacheIndex] = temp;

    int i = blockDim.x / 2;

    __syncthreads();

    // this kind of reduction requires that number of threads is a power of 2

    while(i != 0){

        if(cacheIndex < i){

            cache[cacheIndex] += cache[cacheIndex + i];

        }

        __syncthreads();

        i /= 2;

    }

    if(cacheIndex == 0) result[blockIdx.x] = cache[0];

}

double CUDAOffloader::sendDataToDeviceAndCompute(){

    thrust::complex<double> *c,*cDev;

    c = (thrust::complex<double>*)malloc(10*sizeof(thrust::complex<double>));

    thrust::complex<double> I(0.0,1.0);

    for(int i=0;i<10;i++) c[i] = 1.0 * i + ( i + 0.5 ) * I;

    for(int i=0;i<10;i++) std::cout << "test: " << normC(c[i]) << std::endl;

    double* resultDev;

    double* result;

    result = (double*)malloc(BLOCKS_PER_GRID*sizeof(double));

    cudaMalloc ( (void**)&cDev,10*sizeof(thrust::complex<double>) );

    cudaMalloc ( (void**)&resultDev, BLOCKS_PER_GRID * sizeof(double) );

    cudaMemcpy ( cDev, c, 10*sizeof(thrust::complex<double>), cudaMemcpyHostToDevice );

    dot<<<BLOCKS_PER_GRID,THREADS_PER_BLOCK>>>(cDev,resultDev);

    cudaMemcpy ( result, resultDev, BLOCKS_PER_GRID * sizeof(double), cudaMemcpyDeviceToHost);

    double output = 0.0;

    for(int i=0;i<BLOCKS_PER_GRID;i++) output += result[i];

    cudaFree ( cDev );

    cudaFree ( resultDev );

    free(c);

    free(result);

    return output;

}

void CUDAOffloader::getDeviceProperties(){

    int count;
    cudaGetDeviceCount(&count);
    std::cout << "Number of Devices: " << count << std::endl << std::endl;

    cudaDeviceProp Prop;
    cudaGetDeviceProperties(&Prop,0);
    std::cout << Prop.name << std::endl;
    std::cout << "Amount of memory on device in bytes: " << Prop.totalGlobalMem << std::endl;
    std::cout << "The Maximum amount of shared memory a single block may use in bytes: " << Prop.sharedMemPerBlock << std::endl;
    std::cout << "Max threads per block: " << Prop.maxThreadsPerBlock << std::endl;
    std::cout << "Number of 32-bit registers per block: " << Prop.regsPerBlock << std::endl;
    std::cout << "Maximum Number of blocks along x,y, and z:\n";
    std::cout << Prop.maxGridSize[0] << "\t" << Prop.maxGridSize[1] << "\t" << Prop.maxGridSize[2] << std::endl;
     //more stats you don't understand yet

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
