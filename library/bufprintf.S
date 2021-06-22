# bufprintf 
# is a simple printf implementation that supports %c, %d, %i, %x, %X, %s, %u in their most basic forms.
# It is intended as a very simple debugging tool. 
# The lack of some features likely makes it a poor solution for a generic printf.
# This could be replaced with a more featureful implementation if desired.
# 
# param1 = char* buffer to output final string
# param2 = const char* format to set format of string
# param3+ = variables passed to bind with format string
# 
# This was used as inspiration: https://godbolt.org/z/sgMVs7
.global bufprintf

bpf_formatstring:
        lbu     a4,0(a1)
        beqz    a4,.L45
        addi    sp,sp,-64
        sd      s0,56(sp)
        sd      s1,48(sp)
        sd      s2,40(sp)
        sd      s3,32(sp)
        sd      s4,24(sp)
        sd      s5,16(sp)
        sd      s6,8(sp)
        mv      a5,a0
        li      a7,37
        li      t4,100
        li      a6,9
        li      t1,10
        li      s2,45
        li      t5,15
        li      t3,115
        li      s1,117
        li      s0,120
        li      t2,105
        li      t0,88
        li      t6,99
.L44:
        beq     a4,a7,.L62
        sb      a4,0(a5)
        addi    a1,a1,1
        addi    a5,a5,1
.L43:
        lbu     a4,0(a1)
        bnez    a4,.L44
        sb      zero,0(a5)
        ld      s0,56(sp)
        ld      s1,48(sp)
        ld      s2,40(sp)
        ld      s3,32(sp)
        ld      s4,24(sp)
        ld      s5,16(sp)
        ld      s6,8(sp)
        subw    a0,a5,a0
        addi    sp,sp,64
        jr      ra
.L62:
        lbu     a4,1(a1)
        beq     a4,t4,.L17
        bleu    a4,t4,.L63
        beq     a4,t3,.L23
        bleu    a4,t3,.L64
        bne     a4,s1,.L65
        lw      s3,0(a2)
        li      a4,1
        addi    a2,a2,8
        bleu    s3,a6,.L37
.L34:
        slliw   a3,a4,2
        addw    a4,a3,a4
        slliw   a4,a4,1
        divuw   a3,s3,a4
        bgtu    a3,a6,.L34
.L37:
        sext.w  s5,a4
        divuw   s4,s3,s5
        addi    a5,a5,1
        andi    a3,s4,0xff
        addiw   s6,a3,55
        divw    a4,a4,t1
        addiw   a3,a3,48
        remuw   s3,s3,s5
        ble     s4,a6,.L35
        sb      s6,-1(a5)
        bnez    a4,.L37
.L22:
        addi    a1,a1,2
        j       .L43
.L63:
        beq     a4,t0,.L19
        beq     a4,t6,.L20
        bne     a4,a7,.L22
        sb      a7,0(a5)
        addi    a1,a1,2
        addi    a5,a5,1
        j       .L43
.L65:
        bne     a4,s0,.L22
.L19:
        lw      s3,0(a2)
        li      a4,1
        addi    a2,a2,8
        bleu    s3,t5,.L42
.L39:
        slliw   a4,a4,4
        divuw   a3,s3,a4
        bgtu    a3,t5,.L39
.L42:
        sext.w  s5,a4
        divuw   s4,s3,s5
        addi    a5,a5,1
        srai    a4,a4,4
        andi    a3,s4,0xff
        addiw   s6,a3,55
        remuw   s3,s3,s5
        addiw   a3,a3,48
        ble     s4,a6,.L40
        sb      s6,-1(a5)
        bnez    a4,.L42
        j       .L22
.L64:
        bne     a4,t2,.L22
.L17:
        lw      a4,0(a2)
        addi    a2,a2,8
        bltz    a4,.L66
.L26:
        sext.w  s3,a4
        ble     a4,a6,.L46
        li      a4,1
.L28:
        slliw   a3,a4,2
        addw    a4,a3,a4
        slliw   a4,a4,1
        divuw   a3,s3,a4
        bgtu    a3,a6,.L28
.L31:
        sext.w  s5,a4
        divuw   s4,s3,s5
        addi    a5,a5,1
        andi    a3,s4,0xff
        addiw   s6,a3,55
        divw    a4,a4,t1
        addiw   a3,a3,48
        remuw   s3,s3,s5
        bleu    s4,a6,.L29
        sb      s6,-1(a5)
        bnez    a4,.L31
        j       .L22
.L40:
        sb      a3,-1(a5)
        bnez    a4,.L42
        j       .L22
.L35:
        sb      a3,-1(a5)
        bnez    a4,.L37
        j       .L22
.L29:
        sb      a3,-1(a5)
        bnez    a4,.L31
        j       .L22
.L20:
        lw      a4,0(a2)
        addi    a5,a5,1
        addi    a2,a2,8
        sb      a4,-1(a5)
        addi    a1,a1,2
        j       .L43
.L23:
        ld      a3,0(a2)
        addi    a2,a2,8
        lbu     a4,0(a3)
        beqz    a4,.L22
.L32:
        addi    a5,a5,1
        addi    a3,a3,1
        sb      a4,-1(a5)
        lbu     a4,0(a3)
        bnez    a4,.L32
        addi    a1,a1,2
        j       .L43
.L66:
        sb      s2,0(a5)
        subw    a4,zero,a4
        addi    a5,a5,1
        j       .L26
.L45:
        sb      zero,0(a0)
        subw    a0,a0,a0
        ret
.L46:
        li      a4,1
        j       .L31
bufprintf:
        addi    sp,sp,-80
        addi    t1,sp,32
        sd      a2,32(sp)
        mv      a2,t1
        sd      ra,24(sp)
        sd      a3,40(sp)
        sd      a4,48(sp)
        sd      a5,56(sp)
        sd      a6,64(sp)
        sd      a7,72(sp)
        sd      t1,8(sp)
        call    bpf_formatstring
        ld      ra,24(sp)
        addi    sp,sp,80
        jr      ra