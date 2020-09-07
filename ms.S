.arch armv8-a

.text
.global mergeSort
.global merge

lr      .req x30

/*
  @brief
  Weird and pointless implementation of merge sort
  that stupidly allocates memory and passes allocated
  pointer to caller

  @param[in] pData pointer to data stored in x0
  @param[in] dLeng size of data in bytes stored in pData
  @return ptr to sorted array, should be free()'d later
*/
pDatax  .req x0
dLengx  .req x1
pDEndx  .req x2

mergeSort:
   stp  x0, x1, [sp, -16]!    // push arguments to stack
split:


/*
  @brief

  Given two byte arrays and their respective lengths,
  compare elements of the arrays and add the sorted
  results to a resulting array.

  @param[in] pArrMx pointer to first array, 64 bit
  @param[in] dSizMx size of first array, 64 bit
  @param[in] pArrNx pointer to second array, 64 bit
  @param[in] dSizNx size of second array, 64 bit

  @return ptr to the resulting array

*/
pArrMx  .req x0
dSizMx  .req x1
pArrNx  .req x2
dSizNx  .req x3

pEndMx  .req x1
pEndNx  .req x3

pArrRx  .req x4
dSizRx  .req x5
pEndRx  .req x5

cCurMw  .req w6
cCurNw  .req w7

merge:
allocResult:
  stp   pArrMx, dSizMx, [sp, -16]!// save args on stack
  stp   pArrNx, dSizNx, [sp, -16]!
  add   dSizRx, dSizMx, dSizNx    // calculate size to malloc
  stp   dSizRx, lr, [sp, -16]!    // save size and lr on stack
  mov   x0, dSizRx
  bl    malloc                    // call malloc, creating memory for resulting array
  ldp   dSizRx, lr, [sp], 16      // restore result size and lr
  mov   pArrRx, x0                // save return from malloc to pArrRx
  ldp   pArrNx, dSizNx, [sp], 16  // restore args
  ldp   pArrMx, dSizMx, [sp], 16
calcEndPtrs:
  add   pEndMx, pArrMx, dSizMx    // calculate end ptr of pArrMx, store where dSizeMx was
  add   pEndNx, pArrNx, dSizNx    // calculate end ptr of pArrNx, store where dSizeNx was
  add   pEndRx, pArrRx, dSizRx    // calculate end ptr of pArrRx, store where dSizeRx was
mergeLoop:
  cmp   pEndMx, pArrMx            // check we're not at beginning of array
  beq   flushN

  cmp   pEndNx, pArrNx            // check we're not at beginning of array
  beq   flushM

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
  
loopEnd:
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
  mov   x0, pArrRx
  ret
