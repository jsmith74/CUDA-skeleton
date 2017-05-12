#include <iostream>
#include <ctime>
#include <complex>
#include <iomanip>

#include "CUDAfunc.h"


int main(){

	int test;

	clock_t t1,t2;

	t1 = clock();

    thrust::complex<double> compTestArr[10];

    thrust::complex<double> I(0.0,1.0);

    for(int i=0;i<10;i++) compTestArr[i] = 1.0 * i + ( i + 0.5 ) * I;

    for(int i=0;i<10;i++) std::cout << normC(compTestArr[i]) << std::endl;

    double output = 0.0;

    for(int i=0;i<358400;i++){

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output += normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output -= normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output += normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output -= normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output += normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output -= normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output += normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output -= normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output += normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output -= normC(compTestArr[j]);

        for(int k=0;k<100;k++) for(int j=0;j<10;j++) output += normC(compTestArr[j]);

    }

	t2 = clock();

	float diff = (float)t2 - (float)t1;

	std::cout << "Result: " << std::setprecision(16)  << output << std::endl;

	std::cout << "Time to Execute: " << diff/CLOCKS_PER_SEC << std::endl;

	output = 0.0;

	CUDAOffloader OffloadtoGPU;

	OffloadtoGPU.getDeviceProperties();

	t1 = clock();

	output = OffloadtoGPU.sendDataToDeviceAndCompute();

	t2 = clock();

	diff = (float)t2 - (float)t1;

    std::cout << "Result: " << std::setprecision(16)  << output << std::endl;

	std::cout << "Time to Execute: " << diff/CLOCKS_PER_SEC << std::endl;

	return 0;

}
