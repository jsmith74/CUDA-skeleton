#ifndef BOOTLEGPERMUTATION_H_INCLUDED
#define BOOTLEGPERMUTATION_H_INCLUDED

class BootLegPermutation{

    public:

        BootLegPermutation();
        bool next_permutation(int* __first, int* __last);

    private:

        inline void iter_swap(int* __a, int* __b);
        void reverse(int* __first, int* __last);

};

inline void BootLegPermutation::iter_swap(int* __a, int* __b) {
  int __tmp = *__a;
  *__a = *__b;
  *__b = __tmp;
}

#endif // BOOTLEGPERMUTATION_H_INCLUDED
