.arch armv8-a

.text
.global mergeSort
.global merge
.global retard

lr      .req x30

// param int
// param int
// param int
retard:
  mov x1, x0
  mov x2, x1
  mov x3, x2
  ret

/*
  @brief
  Weird and pointless implementation of merge sort
  that stupidly allocates memory and passes allocated
  pointer to caller and hopes they remember to free
	the pointer

  @param[in]  pData pointer to data stored in x0
  @param[in]  dLeng size of data in bytes stored in pData
	@param[out] pArrRx pointer to storage for result, 64 bit
  @return ptr to sorted array, should be free()'d later
*/
pDatax  .req x0
dLengx  .req x1
pMemRx  .req x2

dTempx  .req x3
dMiddx  .req x4
pMiddx  .req x5
pMidAx  .req x6
dRemLx  .req x7

// ptr pRReturnMem
// ptr pLReturnMem
mergeSort:
_baseCase:
  cmp   dLengx, 1                 // base case len==0
  bne   _allocMem
  // copy input to result
  ldrb   w3, [pDatax, 0]
  strb   w3, [pMemRx, 0]
_done:
  ret
_allocMem:
  // preparing to calculate temporary array on stack, need to consider
  // alignment for sp. Will allocate number of bytes with space for
  // at most another 16 bytes for alignment
  lsr   dTempx, dLengx, 0x4         // divide length by 16 for arr size
  add   dTempx, dTempx, 0x1         // add one in case <16 bytes in length
  lsl   dTempx, dTempx, 0x4         // multiply by 4 again to get aligned number of bytes to alloc
  sub   sp, sp, dTempx              // allocate temp array[dLeng]
  str   dTempx, [sp, -0x10]!        // store size of above array
  // sp now at start of result array
  // the above result array will be split in 2 and used as storage for recursive L+R calls to merge()

_prep:
  lsr   dMiddx, dLengx, 0x1         // divide length / 2 for midpoint
  sub   dRemLx, dLengx, dMiddx      // length - midpoint = remaining length
  add   dTempx, sp, 0x10            // address of start of above array
  add   pMiddx, pDatax, dMiddx      // calculate pointer to middle of input
  add   pMidAx, dTempx, dMiddx      // calculate pointer to middle of allocated result array
  stp   dTempx, pMidAx, [sp, -0x10]!// store pointer to beginning and middle of result array
  stp   pDatax, pMiddx, [sp, -0x10]!// store pData and middle of pData
  stp   dRemLx, dMiddx, [sp, -0x10]!// store remaining length and length/2 (midpoint)
  stp   pMemRx, lr, [sp, -0x10]!    // store pointer to passed mem storage loc and link reg
_recurseL:
  // calculate middle of array, and recurse with first half of pMemR*
  ldr   x0, [sp, 0x20]              // pointer to start of input
  ldr   x1, [sp, 0x18]              // length till middle of input
  ldr   x2, [sp, 0x30]              // pointer to start of above allocated result array
  bl    mergeSort

_recurseR:
  ldr   x0, [sp, 0x28]              // pointer to middle of input
  ldr   x1, [sp, 0x10]              // remaining length from middle to end
  ldr   x2, [sp, 0x38]              // pointer to middle of above allocated result array
  bl    mergeSort
  ldr   lr, [sp, 0x8]               // restore lr

  // results should now be in result array
_merge:
  ldr   x0, [sp, 0x30]              // pointer to first half of result array
  ldr   x1, [sp, 0x18]              // length to middle
  ldr   x2, [sp, 0x38]              // pointer to second half of result array
  ldr   x3, [sp, 0x10]              // remaining length
  ldr   x4, [sp, 0]                 // pointer to result mem passed
  bl    merge
  ldr   lr, [sp, 0x8]               // restore lr

_undoStack:
  ldp   pMemRx, lr, [sp], 16        // restore args and lr
  add   sp, sp, 0x30                // free variables
  ldr   dTempx, [sp], 16            // restore size of allocated array
  add   sp, sp, dTempx              // unallocate array
  b     _done

/*
  @brief

  Given two byte arrays and their respective lengths,
  compare elements of the arrays and merge the sorted
  results to a resulting array.

  @param[in]  pArrMx pointer to first array, 64 bit
  @param[in]  dSizMx size of first array, 64 bit
  @param[in]  pArrNx pointer to second array, 64 bit
  @param[in]  dSizNx size of second array, 64 bit
	@param[out] pArrRx pointer to storage for result, 64 bit

  @return none

*/
pArrMx  .req x0
dSizMx  .req x1
pArrNx  .req x2
dSizNx  .req x3
pArrRx  .req x4

pEndMx  .req x1
pEndNx  .req x3

pArrRx  .req x4
dSizRx  .req x5
pEndRx  .req x5

cCurMw  .req w6
cCurNw  .req w7

merge:
  stp   pArrMx, dSizMx, [sp, -16]!// save args on stack
  stp   pArrNx, dSizNx, [sp, -16]!
  stp   pArrRx, lr, [sp, -16]!    // lr on stack
calcEndPtrs:
  add   dSizRx, dSizMx, dSizNx    // calculate size for result
  add   pEndMx, pArrMx, dSizMx    // calculate end ptr of pArrMx, store where dSizeMx was
  add   pEndNx, pArrNx, dSizNx    // calculate end ptr of pArrNx, store where dSizeNx was
  add   pEndRx, pArrRx, dSizRx    // calculate end ptr of pArrRx, store where dSizeRx was
mergeLoop:
checkEndOfArr:
  cmp   pEndMx, pArrMx            // check we're not at beginning of array
  beq   flushN
  cmp   pEndNx, pArrNx            // check we're not at beginning of array
  beq   flushM
compareBytes:
  ldrb  cCurMw, [pEndMx, -1]!     // decrement end of M and load byte
  ldrb  cCurNw, [pEndNx, -1]!     // decrement end of N and load byte
  cmp   cCurMw, cCurNw            // compare loaded bytes
  blt   resultNByte               // if M < N, then load N at the end of result arr
resultMByte:
  strb  cCurMw, [pEndRx, -1]!     // store M byte at end of result arr
  add   pEndNx, pEndNx, 1         // restore end of N since it wasn't chosen
  b     mergeLoop
resultNByte:
  strb  cCurNw, [pEndRx, -1]!     // store M byte at end of result arr
  add   pEndMx, pEndMx, 1         // restore end of M since it wasn't chosen
  b     mergeLoop    
flushM:
  cmp   pEndMx, pArrMx
  beq   finish
  ldrb  cCurMw, [pEndMx, -1]!     // decrement end of M and load byte
  strb  cCurMw, [pEndRx, -1]!     // store M byte at end of result arr
  b     flushM
flushN:
  cmp   pEndNx, pArrNx
  beq   finish
  ldrb  cCurNw, [pEndNx, -1]!     // decrement end of N and load byte
  strb  cCurNw, [pEndRx, -1]!     // store M byte at end of result arr
  b     flushN
finish:
  ldp   pArrRx, lr, [sp], 16      // restore result size and lr
  ldp   pArrNx, dSizNx, [sp], 16  // restore args
  ldp   pArrMx, dSizMx, [sp], 16
  ret
