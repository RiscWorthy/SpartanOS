.global snprintf_
.global dprintf

snp_itoa:
        li      a5,1
        bltu    a1,a2,.L8
.L3:
        mul     a5,a5,a2
        divu    a4,a1,a5
        bgeu    a4,a2,.L3
        beqz    a5,.L12
.L2:
        li      t3,9
.L6:
        lw      a6,0(a0)
        andi    a3,a4,0xff
        addi    t1,a3,55
        addi    a7,a6,1
        sw      a7,0(a0)
        remu    a1,a1,a5
        addi    a3,a3,48
        div     a5,a5,a2
        ble     a4,t3,.L4
        sb      t1,0(a6)
        beqz    a5,.L1
.L13:
        divu    a4,a1,a5
        j       .L6
.L4:
        sb      a3,0(a6)
        bnez    a5,.L13
.L1:
        ret
.L12:
        ret
.L8:
        mv      a4,a1
        j       .L2
snp_formatstring:
        addi    sp,sp,-32
        sw      s0,28(sp)
        sw      s1,24(sp)
        sw      s2,20(sp)
        sw      s3,16(sp)
        sw      s4,12(sp)
        sw      s5,8(sp)
        sw      s6,4(sp)
        mv      a5,a0
        add     a1,a0,a1
        li      t3,37
        li      t6,100
        li      a6,9
        li      t4,10
        li      s4,45
        li      t0,15
        li      t5,115
        li      s3,117
        li      s2,120
        li      s1,105
        li      s0,88
        li      t2,99
.L15:
        lbu     a4,0(a2)
        beqz    a4,.L44
.L64:
        bgeu    a5,a1,.L44
        beq     a4,t3,.L63
        sb      a4,0(a5)
        addi    a2,a2,1
        lbu     a4,0(a2)
        addi    a5,a5,1
        bnez    a4,.L64
.L44:
        sb      zero,0(a5)
        lw      s0,28(sp)
        lw      s1,24(sp)
        lw      s2,20(sp)
        lw      s3,16(sp)
        lw      s4,12(sp)
        lw      s5,8(sp)
        lw      s6,4(sp)
        sub     a0,a5,a0
        addi    sp,sp,32
        jr      ra
.L63:
        lbu     a4,1(a2)
        beq     a4,t6,.L17
        bleu    a4,t6,.L65
        beq     a4,t5,.L23
        bleu    a4,t5,.L66
        bne     a4,s3,.L67
        lw      t1,0(a3)
        li      a4,1
        addi    a3,a3,4
        bleu    t1,a6,.L37
.L34:
        slli    a7,a4,2
        add     a4,a7,a4
        slli    a4,a4,1
        divu    a7,t1,a4
        bgtu    a7,a6,.L34
.L37:
        divu    s5,t1,a4
        addi    a5,a5,1
        andi    a7,s5,0xff
        addi    s6,a7,55
        remu    t1,t1,a4
        addi    a7,a7,48
        div     a4,a4,t4
        ble     s5,a6,.L35
        sb      s6,-1(a5)
        bnez    a4,.L37
.L22:
        addi    a2,a2,2
        j       .L15
.L65:
        beq     a4,s0,.L19
        beq     a4,t2,.L20
        bne     a4,t3,.L22
        sb      t3,0(a5)
        addi    a2,a2,2
        addi    a5,a5,1
        j       .L15
.L67:
        bne     a4,s2,.L22
.L19:
        lw      s5,0(a3)
        li      a4,1
        addi    a3,a3,4
        bleu    s5,t0,.L49
.L39:
        slli    a4,a4,4
        divu    a7,s5,a4
        bgtu    a7,t0,.L39
.L42:
        andi    t1,a7,0xff
        addi    s6,t1,55
        remu    s5,s5,a4
        addi    t1,t1,48
        addi    a5,a5,1
        srai    a4,a4,4
        ble     a7,a6,.L40
.L68:
        sb      s6,-1(a5)
.L41:
        beqz    a4,.L22
        addi    a5,a5,1
        divu    a7,s5,a4
        andi    t1,a7,0xff
        addi    s6,t1,55
        remu    s5,s5,a4
        addi    t1,t1,48
        srai    a4,a4,4
        bgt     a7,a6,.L68
.L40:
        sb      t1,-1(a5)
        j       .L41
.L66:
        bne     a4,s1,.L22
.L17:
        lw      s5,0(a3)
        addi    a3,a3,4
        bltz    s5,.L69
.L26:
        mv      t1,s5
        li      a4,1
        ble     s5,a6,.L31
.L28:
        slli    a7,a4,2
        add     a4,a7,a4
        slli    a4,a4,1
        divu    a7,s5,a4
        bgtu    a7,a6,.L28
.L31:
        divu    s5,t1,a4
        addi    a5,a5,1
        andi    a7,s5,0xff
        addi    s6,a7,55
        remu    t1,t1,a4
        addi    a7,a7,48
        div     a4,a4,t4
        bleu    s5,a6,.L29
.L70:
        sb      s6,-1(a5)
        beqz    a4,.L22
.L62:
        addi    a5,a5,1
        divu    s5,t1,a4
        andi    a7,s5,0xff
        addi    s6,a7,55
        remu    t1,t1,a4
        addi    a7,a7,48
        div     a4,a4,t4
        bgtu    s5,a6,.L70
.L29:
        sb      a7,-1(a5)
        bnez    a4,.L62
        j       .L22
.L35:
        sb      a7,-1(a5)
        bnez    a4,.L37
        j       .L22
.L23:
        lw      a7,0(a3)
        addi    a3,a3,4
        lbu     a4,0(a7)
        beqz    a4,.L22
.L32:
        addi    a5,a5,1
        addi    a7,a7,1
        sb      a4,-1(a5)
        lbu     a4,0(a7)
        bnez    a4,.L32
        addi    a2,a2,2
        j       .L15
.L20:
        lw      a4,0(a3)
        addi    a5,a5,1
        addi    a3,a3,4
        sb      a4,-1(a5)
        addi    a2,a2,2
        j       .L15
.L69:
        sb      s4,0(a5)
        sub     s5,zero,s5
        addi    a5,a5,1
        j       .L26
.L49:
        mv      a7,s5
        j       .L42
snprintf_:
        addi    sp,sp,-64
        addi    t1,sp,44
        sw      a3,44(sp)
        mv      a3,t1
        sw      ra,28(sp)
        sw      a4,48(sp)
        sw      a5,52(sp)
        sw      a6,56(sp)
        sw      a7,60(sp)
        sw      t1,12(sp)
        call    snp_formatstring
        lw      ra,28(sp)
        addi    sp,sp,64
        jr      ra
dprintf:
        addi    sp,sp,-64
        addi    t1,a0,15
        sw      s0,24(sp)
        sw      ra,28(sp)
        addi    s0,sp,32
        sw      s1,20(sp)
        andi    t1,t1,-16
        sub     sp,sp,t1
        addi    t1,s0,8
        sw      a2,8(s0)
        sw      a3,12(s0)
        mv      a2,a1
        mv      a3,t1
        mv      a1,a0
        mv      a0,sp
        sw      a4,16(s0)
        sw      a5,20(s0)
        sw      a6,24(s0)
        sw      a7,28(s0)
        sw      t1,-20(s0)
        call    snp_formatstring
        lbu     a0,0(sp)
        beqz    a0,.L73
        mv      s1,sp
.L75:
        addi    s1,s1,1
        call    uart_putc_sync
        lbu     a0,0(s1)
        bnez    a0,.L75
.L73:
        addi    sp,s0,-32
        lw      ra,28(sp)
        lw      s0,24(sp)
        lw      s1,20(sp)
        addi    sp,sp,64
        jr      ra