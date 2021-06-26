# snprintf 
# is a simple snprintf implementation that supports %c, %d, %i, %x, %X, %s, %u in their most basic forms.
# It is intended as a very simple debugging tool. 
# The lack of some features likely makes it a poor solution for a generic snprintf.
# This could be replaced with a more featureful implementation if desired.
# 
# param1 = char* buffer to output final string
# param2 = int length to cap buffer, preventing overflow
# param3 = const char* format to set format of string
# param4+ = variables passed to bind with format string
# 
# This was used as inspiration: https://godbolt.org/z/sgMVs7
.global snprintf_
.global dprintf

snp_itoa:
        sext.w  a3,a2
        li      a5,1
        bltu    a1,a3,.L2
.L3:
        mulw    a5,a2,a5
        divuw   a4,a1,a5
        bgeu    a4,a3,.L3
        beqz    a5,.L12
.L2:
        li      t4,9
.L6:
        sext.w  a7,a5
        divuw   a6,a1,a7
        ld      a3,0(a0)
        addi    t1,a3,1
        sd      t1,0(a0)
        andi    a4,a6,0xff
        addiw   t3,a4,55
        divw    a5,a5,a2
        addiw   a4,a4,48
        remuw   a1,a1,a7
        ble     a6,t4,.L4
        sb      t3,0(a3)
        bnez    a5,.L6
.L13:
        ret
.L4:
        sb      a4,0(a3)
        bnez    a5,.L6
        j       .L13
.L12:
        ret
snp_formatstring:
        addi    sp,sp,-64
        sd      s0,56(sp)
        sd      s1,48(sp)
        sd      s2,40(sp)
        sd      s3,32(sp)
        sd      s4,24(sp)
        sd      s5,16(sp)
        sd      s6,8(sp)
        sd      s7,0(sp)
        mv      a5,a0
        add     a1,a0,a1
        li      t1,37
        li      t5,100
        li      a7,9
        li      t3,10
        li      s3,45
        li      t6,15
        li      t4,115
        li      s2,117
        li      s1,120
        li      s0,105
        li      t2,88
        li      t0,99
.L15:
        lbu     a4,0(a2)
        beqz    a4,.L44
.L62:
        bgeu    a5,a1,.L44
        beq     a4,t1,.L61
        sb      a4,0(a5)
        addi    a2,a2,1
        lbu     a4,0(a2)
        addi    a5,a5,1
        bnez    a4,.L62
.L44:
        sb      zero,0(a5)
        ld      s0,56(sp)
        ld      s1,48(sp)
        ld      s2,40(sp)
        ld      s3,32(sp)
        ld      s4,24(sp)
        ld      s5,16(sp)
        ld      s6,8(sp)
        ld      s7,0(sp)
        subw    a0,a5,a0
        addi    sp,sp,64
        jr      ra
.L61:
        lbu     a4,1(a2)
        beq     a4,t5,.L17
        bleu    a4,t5,.L63
        beq     a4,t4,.L23
        bleu    a4,t4,.L64
        bne     a4,s2,.L65
        lw      s4,0(a3)
        li      a4,1
        addi    a3,a3,8
        bleu    s4,a7,.L37
.L34:
        slliw   a6,a4,2
        addw    a4,a6,a4
        slliw   a4,a4,1
        divuw   a6,s4,a4
        bgtu    a6,a7,.L34
.L37:
        sext.w  s6,a4
        divuw   s5,s4,s6
        addi    a5,a5,1
        andi    a6,s5,0xff
        addiw   s7,a6,55
        divw    a4,a4,t3
        addiw   a6,a6,48
        remuw   s4,s4,s6
        ble     s5,a7,.L35
        sb      s7,-1(a5)
        bnez    a4,.L37
.L22:
        addi    a2,a2,2
        j       .L15
.L63:
        beq     a4,t2,.L19
        beq     a4,t0,.L20
        bne     a4,t1,.L22
        sb      t1,0(a5)
        addi    a2,a2,2
        addi    a5,a5,1
        j       .L15
.L65:
        bne     a4,s1,.L22
.L19:
        lw      s4,0(a3)
        li      a4,1
        addi    a3,a3,8
        bleu    s4,t6,.L42
.L39:
        slliw   a4,a4,4
        divuw   a6,s4,a4
        bgtu    a6,t6,.L39
.L42:
        sext.w  s6,a4
        divuw   s5,s4,s6
        addi    a5,a5,1
        srai    a4,a4,4
        andi    a6,s5,0xff
        addiw   s7,a6,55
        remuw   s4,s4,s6
        addiw   a6,a6,48
        ble     s5,a7,.L40
        sb      s7,-1(a5)
        bnez    a4,.L42
        j       .L22
.L64:
        bne     a4,s0,.L22
.L17:
        lw      a4,0(a3)
        addi    a3,a3,8
        bltz    a4,.L66
.L26:
        sext.w  s4,a4
        ble     a4,a7,.L46
        li      a4,1
.L28:
        slliw   a6,a4,2
        addw    a4,a6,a4
        slliw   a4,a4,1
        divuw   a6,s4,a4
        bgtu    a6,a7,.L28
.L31:
        sext.w  s6,a4
        divuw   s5,s4,s6
        addi    a5,a5,1
        andi    a6,s5,0xff
        addiw   s7,a6,55
        divw    a4,a4,t3
        addiw   a6,a6,48
        remuw   s4,s4,s6
        bleu    s5,a7,.L29
        sb      s7,-1(a5)
        bnez    a4,.L31
        j       .L22
.L40:
        sb      a6,-1(a5)
        bnez    a4,.L42
        j       .L22
.L35:
        sb      a6,-1(a5)
        bnez    a4,.L37
        j       .L22
.L29:
        sb      a6,-1(a5)
        bnez    a4,.L31
        j       .L22
.L23:
        ld      a6,0(a3)
        addi    a3,a3,8
        lbu     a4,0(a6)
        beqz    a4,.L22
.L32:
        addi    a5,a5,1
        addi    a6,a6,1
        sb      a4,-1(a5)
        lbu     a4,0(a6)
        bnez    a4,.L32
        addi    a2,a2,2
        j       .L15
.L20:
        lw      a4,0(a3)
        addi    a5,a5,1
        addi    a3,a3,8
        sb      a4,-1(a5)
        addi    a2,a2,2
        j       .L15
.L66:
        sb      s3,0(a5)
        subw    a4,zero,a4
        addi    a5,a5,1
        j       .L26
.L46:
        li      a4,1
        j       .L31
snprintf_:
        addi    sp,sp,-80
        addi    t1,sp,40
        sd      a3,40(sp)
        mv      a3,t1
        sd      ra,24(sp)
        sd      a4,48(sp)
        sd      a5,56(sp)
        sd      a6,64(sp)
        sd      a7,72(sp)
        sd      t1,8(sp)
        call    snp_formatstring
        ld      ra,24(sp)
        addi    sp,sp,80
        jr      ra
dprintf:
        addi    sp,sp,-96
        addi    t1,a0,15
        sd      s0,32(sp)
        sd      ra,40(sp)
        addi    s0,sp,48
        sd      s1,24(sp)
        andi    t1,t1,-16
        sub     sp,sp,t1
        sd      a2,0(s0)
        sd      a3,8(s0)
        mv      a2,a1
        mv      a3,s0
        mv      a1,a0
        mv      a0,sp
        sd      a4,16(s0)
        sd      a5,24(s0)
        sd      a6,32(s0)
        sd      a7,40(s0)
        sd      s0,-40(s0)
        call    snp_formatstring
        lbu     a0,0(sp)
        beqz    a0,.L69
        mv      s1,sp
.L71:
        addi    s1,s1,1
        call    uart_putc_sync
        lbu     a0,0(s1)
        bnez    a0,.L71
.L69:
        addi    sp,s0,-48
        ld      ra,40(sp)
        ld      s0,32(sp)
        ld      s1,24(sp)
        addi    sp,sp,96
        jr      ra