#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

extern void mergeSort( uint8_t* buf, size_t len, uint8_t* res );
extern void merge( uint8_t* bufm, size_t lenm, uint8_t* bufn, size_t lenn, uint8_t* bufr );
int cmp( uint8_t* res, uint8_t* exp, size_t len );
void printArr( uint8_t* arr, size_t len );

int main()
{

   // merge() tests
   {
      printf("Test 1");
      uint8_t m[] = { 1 };
      uint8_t n[] = { 1 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 1 };
      uint8_t res[((sizeof(m) + sizeof(n))/sizeof(uint8_t))] = {};
      merge( m, mlen, n, nlen, res );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
   }
   {
      printf("Test 2");
      uint8_t m[] = { 1 };
      uint8_t n[] = { 2 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2 };
      uint8_t res[((sizeof(m) + sizeof(n))/sizeof(uint8_t))] = {};
      merge( m, mlen, n, nlen, res );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
   }
   {
      printf("Test 3");
      uint8_t m[] = { 2 };
      uint8_t n[] = { 1 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2 };
      uint8_t res[((sizeof(m) + sizeof(n))/sizeof(uint8_t))] = {};
      merge( m, mlen, n, nlen, res );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
   }
   {
      printf("Test 4");
      uint8_t m[] = { 2, 4 };
      uint8_t n[] = { 1, 3 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4 };
      uint8_t res[((sizeof(m) + sizeof(n))/sizeof(uint8_t))] = {};
      merge( m, mlen, n, nlen, res );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
   }
   {
      printf("Test 5");
      uint8_t m[] = { 2 };
      uint8_t n[] = { 1, 3 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3 };
      uint8_t res[((sizeof(m) + sizeof(n))/sizeof(uint8_t))] = {};
      merge( m, mlen, n, nlen, res );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
   }
   {
      printf("Test 6");
      uint8_t m[] = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 };
      uint8_t n[] = { 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };
      uint8_t res[((sizeof(m) + sizeof(n))/sizeof(uint8_t))] = {};
      merge( m, mlen, n, nlen, res );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
   }
   {
      printf("Test 7");
      uint8_t m[] = { 1 };
      uint8_t n[] = { 2, 3, 4, 5, 6, 7 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4, 5, 6, 7 };
      uint8_t res[((sizeof(m) + sizeof(n))/sizeof(uint8_t))] = {};
      merge( m, mlen, n, nlen, res );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
   }
   {
      printf("Test 8");
      uint8_t m[] = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 };
      uint8_t n[] = { 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };
      uint8_t mexp[] = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 };
      uint8_t nexp[] = { 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 };
      uint8_t res[((sizeof(m) + sizeof(n))/sizeof(uint8_t))] = {};
      merge( m, mlen, n, nlen, res );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
      assert(cmp(m, mexp, (sizeof(mexp) / sizeof(uint8_t))));
      assert(cmp(n, nexp, (sizeof(nexp) / sizeof(uint8_t))));
   }
   // merge sort tests
   {
      printf("Test 8");
      uint8_t test[] = { 45 };
      const size_t len = sizeof(test) / sizeof(uint8_t);

      uint8_t exp[] = { 45 };
      uint8_t res[len];
      mergeSort( test, len, res );
      assert(cmp(res, exp, len));
   }
   {
      printf("Test 9");
      uint8_t test[] = { 2, 1 };
      const size_t len = sizeof(test) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2 };
      uint8_t res[len];
      mergeSort( test, len, res );
      assert(cmp(res, exp, len));
   }

   {
      printf("Test 10");
      uint8_t test[] = { 2, 4, 1, 3 };
      const size_t len = sizeof(test) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4};
      uint8_t res[len];
      mergeSort( test, len, res );
      assert(cmp(res, exp, len));
   }
   {
      printf("Test 11");
      uint8_t test[] = { 4, 3, 2, 1 };
      size_t len = sizeof(test) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4 };
      uint8_t res[len];
      mergeSort( test, len, res );
      assert(cmp(res, exp, len));
   }

   {
      printf("Test 12");
      uint8_t test[] = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 };
      size_t len = sizeof(test) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };
      uint8_t res[len];
      mergeSort( test, len, res );
      assert(cmp(res, exp, len ));
   }

   {
      printf("Test 13");
      uint8_t test[] = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
         1, 3, 5, 7, 9, 11, 13, 15, 17, 19,
         22, 24, 26, 28, 30, 32, 34, 36, 38, 40,
         21, 23, 25, 27, 29, 31, 33, 35, 37, 39 };
      size_t len = sizeof(test) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
         21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
         31, 32, 33, 34, 35, 36, 37, 38, 39, 40 };
      uint8_t res[len];
      mergeSort( test, len, res );
      assert(cmp(res, exp, len ));
   }
}

int cmp( uint8_t* res, uint8_t* exp, size_t len )
{
   for( size_t i=0; i<len; i++ )
   {
      if( res[i] != exp[i] )
      {
         printf("\t:: fail \n");
         printf("Result: ");
         printArr( res, len );
         printf("\n");
         printf("Expect: ");
         printArr( exp, len );
         fflush(stdout);
         return false;
      }
   }
   printf("\t:: pass \n");
   return true;
}

void printArr( uint8_t* arr, size_t len )
{
   for( size_t i=0; i<len; i++ )
   {
      printf("%d ", arr[i]);
   }

}
