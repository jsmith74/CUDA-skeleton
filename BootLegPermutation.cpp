#include "BootLegPermutation.h"


BootLegPermutation::BootLegPermutation(){

}

void BootLegPermutation::reverse(int* __first, int* __last) {

  while (true)
    if (__first == __last || __first == --__last)
      return;
    else{
      iter_swap(__first++, __last);
    }
}

bool BootLegPermutation::next_permutation(int* __first, int* __last) {

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

