#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdbool.h>

extern uint8_t* bubblesortInPlace( uint8_t* buf );
int cmp( uint8_t* res, uint8_t* exp, size_t len );

int main()
{
   {
      uint8_t test[] = { 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 };
      bubblesortInPlace(test);
      uint8_t exp[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 };
      assert(cmp(test, exp, (sizeof(test) / sizeof(uint8_t))));
   }

   {
      char test[] = "83474321";
      bubblesortInPlace(test);
      char exp[] = "12334478";
      assert(cmp(test, exp, (sizeof(test) / sizeof(char))));
   }
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
