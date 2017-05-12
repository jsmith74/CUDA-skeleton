#ifndef CUDAFUNC_H_INCLUDED
#define CUDAFUNC_H_INCLUDED

#include<thrust/complex.h>

class CUDAOffloader{

    public:

        CUDAOffloader();

        double sendDataandCompute(thrust::complex<double> U[]);

    private:


};

#endif // CUDAFUNC_H_INCLUDED
