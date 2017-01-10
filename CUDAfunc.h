#include <iostream>
#include <string>

class CUDAOffloader{

    public:

        CUDAOffloader();
        void getDeviceProperties();
        void add(int& test,int a,int b);

    private:

       //cudaDeviceProp prop;
       //void addCUDA( int *a, int *b, int *c );

};
