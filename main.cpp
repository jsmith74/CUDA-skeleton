#include <iostream>
#include <assert.h>

inline void iter_swap(int* __a, int* __b) {
  int __tmp = *__a;
  *__a = *__b;
  *__b = __tmp;
}

void reverse(int* __first, int* __last) {

  while (true)
    if (__first == __last || __first == --__last)
      return;
    else{
      iter_swap(__first++, __last);
    }
}

bool next_permutation(int* __first, int* __last) {

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

void printArr(int i[]){

    for(int j=0;j<10;j++) std::cout << i[j] << " ";
    std::cout << std::endl;

}

int main(){

    int i[10];

    for(int j=0;j<10;j++) i[j] = j;

    int k=0;

    do{

        printArr(i);

        k++;

    } while(next_permutation( i,i+10) );

    std::cout << "Num Permutations: " << k << std::endl;

    printArr(i);

    return 0;

}
