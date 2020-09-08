#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

extern uint8_t* mergeSort( uint8_t* buf, size_t len );
extern uint8_t* merge( uint8_t* bufm, size_t lenm, uint8_t* bufn, size_t lenn );
int cmp( uint8_t* res, uint8_t* exp, size_t len );

int main()
{

   // merge() tests
   {
      uint8_t m[] = { 1 };
      uint8_t n[] = { 1 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 1 };
      uint8_t* res = merge( m, mlen, n, nlen );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
      free(res);
   }
   {
      uint8_t m[] = { 1 };
      uint8_t n[] = { 2 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2 };
      uint8_t* res = merge( m, mlen, n, nlen );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
      free(res);
   }
   {
      uint8_t m[] = { 2 };
      uint8_t n[] = { 1 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2 };
      uint8_t* res = merge( m, mlen, n, nlen );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
      free(res);
   }
   {
      uint8_t m[] = { 2, 4 };
      uint8_t n[] = { 1, 3 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4 };
      uint8_t* res = merge( m, mlen, n, nlen );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
      free(res);
   }
   {
      uint8_t m[] = { 2 };
      uint8_t n[] = { 1, 3 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3 };
      uint8_t* res = merge( m, mlen, n, nlen );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
      free(res);
   }
   {
      uint8_t m[] = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 };
      uint8_t n[] = { 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };
      uint8_t* res = merge( m, mlen, n, nlen );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
      free(res);
   }
   {
      uint8_t m[] = { 1 };
      uint8_t n[] = { 2, 3, 4, 5, 6, 7 };
      size_t mlen = sizeof(m) / sizeof(uint8_t);
      size_t nlen = sizeof(n) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2, 3, 4, 5, 6, 7 };
      uint8_t* res = merge( m, mlen, n, nlen );
      assert(cmp(res, exp, (sizeof(exp) / sizeof(uint8_t))));
      free(res);
   }
   // merge sort tests
   {
      uint8_t test[] = { 2, 1 };
      size_t len = sizeof(test) / sizeof(uint8_t);

      uint8_t exp[] = { 1, 2 };
      uint8_t* res = mergeSort( test, len );
      assert(cmp(res, exp, len));
      free(res);
   }

//   {
//      uint8_t test[] = { 4, 3, 2, 1 };
//      mergeSort( test, (sizeof(test) / sizeof(uint8_t)) );
//      uint8_t exp[] = { 1, 2, 3, 4 };
//      assert(cmp(test, exp, (sizeof(test) / sizeof(uint8_t))));
//   }
//
//   {
//      char test[] = "83474321";
//      char exp[] = "12334478";
//      assert(cmp(test, exp, (sizeof(test) / sizeof(char))));
//   }
}

int cmp( uint8_t* res, uint8_t* exp, size_t len )
{
   for( size_t i=0; i<len; i++ )
   {
      if( res[i] != exp[i] )
      {
         printf("Test fail \n");
         return false;
      }
   }
   printf("Test pass \n");
   return true;
}
