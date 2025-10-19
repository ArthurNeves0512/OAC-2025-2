.data
v:
    .word   9,2,5,1,8,2,4,3,6,7,10,2,32,54,2,12,6,3,1,78
    .word   54,23,1,54,2,65,3,6,55,31
.text
main:
    addi    sp,sp,-16
    sw      ra,12(sp)
    sw      s0,8(sp)
    addi    s0,sp,16
    li      a1,30
    lui     a5,0x10010        
    addi    a0,a5,0          
    jal     show
    li      a1,30
    lui     a5,0x10010
    addi    a0,a5,0
    jal     sort
    li      a1,30
    lui     a5,0x10010
    addi    a0,a5,0
    jal     show
    lw      ra,12(sp)
    lw      s0,8(sp)
    addi    sp,sp,16
    li      a7,10
    ecall
show:
    mv      t0,a0
    mv      t1,a1
    mv      t2,zero
loop1:
    beq     t2,t1,fim1
    li      a7,1
    lw      a0,0(t0)
    ecall
    li      a7,11
    li      a0,9
    ecall
    addi    t0,t0,4
    addi    t2,t2,1
    j       loop1
fim1:
    li      a7,11
    li      a0,10
    ecall
    ret
swap:
    addi    sp,sp,-48
    sw      ra,44(sp)
    sw      s0,40(sp)
    addi    s0,sp,48
    sw      a0,-36(s0)
    sw      a1,-40(s0)
    lw      a5,-40(s0)
    slli    a5,a5,2
    lw      a4,-36(s0)
    add     a5,a4,a5
    lw      a5,0(a5)
    sw      a5,-20(s0)
    lw      a5,-40(s0)
    addi    a5,a5,1
    slli    a5,a5,2
    lw      a4,-36(s0)
    add     a4,a4,a5
    lw      a5,-40(s0)
    slli    a5,a5,2
    lw      a3,-36(s0)
    add     a5,a3,a5
    lw      a4,0(a4)
    sw      a4,0(a5)
    lw      a5,-40(s0)
    addi    a5,a5,1
    slli    a5,a5,2
    lw      a4,-36(s0)
    add     a5,a4,a5
    lw      a4,-20(s0)
    sw      a4,0(a5)
    lw      ra,44(sp)
    lw      s0,40(sp)
    addi    sp,sp,48
    ret
sort:
    ble     a1,zero,.L4
    li      a6,-1
    add     a7,a1,a6
    mv      a1,a6
.L7:
    mv      a4,a6
    mv      a5,a0
    bne     a6,a1,.L6
    j       .L8
.L9:
    sw      a3,-4(a5)
    sw      a2,0(a5)
    addi    a5,a5,-4
    beq     a4,a1,.L8
.L6:
    lw      a2,-4(a5)
    lw      a3,0(a5)
    addi    a4,a4,-1
    bgt     a2,a3,.L9
.L8:
    addi    a6,a6,1
    addi    a0,a0,4
    bne     a7,a6,.L7
    ret
.L4:
    ret
