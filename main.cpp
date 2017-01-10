#include <iostream>
#include "CUDAfunc.h"


int main(){

	int test;

	CUDAOffloader OffloadtoGPU;

	OffloadtoGPU.getDeviceProperties();

	OffloadtoGPU.add(test,4,7);

	std::cout << test << std::endl;

	return 0;

}
