
.arch armv8-a
.text
.global bubblesortInPlace

/*
    @brief
        Toy implementation of bubblesort. Will sort any set of NULL
        terminated bytes and return the sorted array. This function
        sorts in place (will not allocate memory) hence it is not
        reccommended to use any memory intended to be read only.

    @param[in] pData pointer to data stored in x0
    @return ptr to sorted array
*/

pDatax  .req x0
cCurrw  .req w1
cNextw  .req w2
pCurrx  .req x3
pNextx  .req x4
bSwapx  .req x5

bubblesortInPlace:
    sub     x1, x1, 1
    mov     bSwapx, 1                   // initialize swapped flag to 1
bsIteration:
    cbz     bSwapx, bsDone              // if swap flag not set, end algorithm
    mov     bSwapx, 0                   // initialize swap flag to 1
    mov     pNextx, pDatax
bsLoop:
    mov     pCurrx, pNextx              // pCurr = pNext
    ldrb    cCurrw, [pNextx], 1         // load first byte then advance pCurr to next

    ldrb    cNextw, [pNextx, 0]!        // load next byte
    cbz     cNextw, bsIteration         // if next byte is null, we at end, new iteration
    cmp     cCurrw, cNextw              // else compare current and next
    ccmp    cCurrw, cNextw, 0x8, ne     // if current not equal to next, set flags to N!=V
    blt     bsLoop                      // if N!=V, branch
    strb    cNextw, [pCurrx], 1         // else then next > current, swap bytes, store next in current, advance
    strb    cCurrw, [pCurrx]            // store current in next
    mov     bSwapx, 1                   // set swapped flag
    b       bsLoop                      // continue
bsDone:
    ret
