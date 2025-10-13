.data
N: .word 8
x: .float 1.0, 3.0, 2.0, 1.0, 1.0, 1.0, 2.0, 1.0
X_real: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
X_imag: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

.text
  # equivalent C function:
  # void DFT(float *x, float *X_real, float *X_imag, int N)
  #This procedure will use the following registers:
    # - A0 x
    # - A1 X_real
    # - A2 X_imag
    # - A3 N
main:

  la a0, x
  la a1, X_real
  la a2, X_imag
  lw a3, N
  
  fcvt.s.d f2,f2#setup register for single precision
  fcvt.s.d f1,f1#setup register for single precision
  
 # List of registers used and reponsibilities
 # t0 -> count used by iterator
 # t1 -> float vector iterator
 # f2 ->
 # f1 ->
dftLoop:
  slli t1,t0,2
  addi t0,t0,1
  add t1,t1,a0
  flw f2,0(t1)
  fadd.s f1,f1,f2
  blt t0,a3,dftLoop

exit:


