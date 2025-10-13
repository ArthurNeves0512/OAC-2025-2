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
 # t1 -> iterator used by the tree vectors. x[t1+a0] X_real[ti+a1] X_imag[t1+a2]
 # f2 ->x[t1]
dftLoop:
  jal ra,iteratorIncrement
  
  jal ra,xVectorIteration
 
  jal ra,x_RealVectorIteration

  jal ra,x_ImagVectorIteration

  blt t0,a3,dftLoop
  jal zero,exit

iteratorIncrement:
  slli t1,t0,2
  addi t0,t0,1
  jalr zero,0(ra)

xVectorIteration:
# fazer a manipualçao aqui para calcular o cos e seno.
# aqui eu so to somando todos os elementos pra checar se a operacao estava sendo feita certa
  add t2,t1,a0
  flw f2,0(t2) 
  fadd.s f1,f1,f2 
  jalr zero,0(ra)

x_RealVectorIteration:
# fazer a manipualçao aqui com o cos.
# aqui eu so to somando todos os elementos pra checar se a operacao estava sendo feita certa
  add t2,t1,a1
  flw f2,0(t2) 
  fadd.s f1,f1,f2 
  jalr zero,0(ra)

x_ImagVectorIteration:
# fazer a manipualçao aqui com o seno.
# aqui eu so to somando todos os elementos pra checar se a operacao estava sendo feita certa
  add t2,t1,a2
  flw f2,0(t2) 
  fadd.s f1,f1,f2 
  jalr zero,0(ra)

exit:


