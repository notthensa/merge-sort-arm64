.arch armv8-a

.text
.global mergeSort
.global merge

lr      .req x30

/*
  @brief
  Weird and pointless implementation of merge sort
  that stupidly allocates memory and passes allocated
  pointer to caller and hopes they remember to free
	the pointer

  @param[in] pData pointer to data stored in x0
  @param[in] dLeng size of data in bytes stored in pData
  @return ptr to sorted array, should be free()'d later
*/
pDatax  .req x0
dLengx  .req x1
dMidpx  .req x2
pMidpx  .req x3

mergeSort:
  str   lr, [sp, -16]!            // save lr on stack
  cmp   dLengx, 1                 // base case len==1
  beq   done
  lsr   dMidpx, dLengx, 2         // divide length by 2 to get mid idx
  add   dMidpx, dMidpx, 1         // add 1 to midpoint
  add   pMidpx, pDatax, dMidpx    // calculate ptr of middle of arr
  stp   pDatax, dMidpx, [sp, -16]!// store ptr to start of arr and mid idx len on stack
  sub   dLengx, dLengx, dMidpx    // calculate remaining length of arr
  stp   pMidpx, dLengx, [sp, -16]!// store ptr to mid of arr and remaining len on stack
  // left side arr ptr is already in x0 (pDatax)
  mov   x1, dMidpx                // place new length (length/2) in x1, recurse
  bl    mergeSort                 // recurse on first half of array
  ldp   x0, x1, [sp, 16]          // get back the address and legth of the mid array
  bl    mergeSort                 // recurse of second half of array
  ldp   pMidpx, dLengx, [sp], 16  // restore ptr to mid of arr and remaining len
  ldp   pDatax, dMidpx, [sp], 16  // store ptr to start of arr and mid idx len on stack
  mov   x0, pDatax
  mov   x1, dMidpx
  mov   x2, pMidpx
  mov   x3, dLengx
  bl    merge
  ldr   lr, [sp], 16
done:
  ret





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
  mov   x0, pArrRx
  ret
