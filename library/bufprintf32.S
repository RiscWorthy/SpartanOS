.global bufprintf

bpf_formatstring:
        lbu     a4,0(a1)
        beqz    a4,.L45
        addi    sp,sp,-32
        sw      s0,28(sp)
        sw      s1,24(sp)
        sw      s2,20(sp)
        sw      s3,16(sp)
        sw      s4,12(sp)
        sw      s5,8(sp)
        mv      a5,a0
        li      t1,37
        li      t5,100
        li      a3,9
        li      t3,10
        li      s3,45
        li      t6,15
        li      t4,115
        li      s2,117
        li      s1,120
        li      s0,105
        li      t2,88
        li      t0,99
.L44:
        beq     a4,t1,.L64
        sb      a4,0(a5)
        addi    a1,a1,1
        addi    a5,a5,1
.L43:
        lbu     a4,0(a1)
        bnez    a4,.L44
        sb      zero,0(a5)
        lw      s0,28(sp)
        lw      s1,24(sp)
        lw      s2,20(sp)
        lw      s3,16(sp)
        lw      s4,12(sp)
        lw      s5,8(sp)
        sub     a0,a5,a0
        addi    sp,sp,32
        jr      ra
.L64:
        lbu     a4,1(a1)
        beq     a4,t5,.L17
        bleu    a4,t5,.L65
        beq     a4,t4,.L23
        bleu    a4,t4,.L66
        bne     a4,s2,.L67
        lw      a7,0(a2)
        li      a4,1
        addi    a2,a2,4
        bleu    a7,a3,.L37
.L34:
        slli    a6,a4,2
        add     a4,a6,a4
        slli    a4,a4,1
        divu    a6,a7,a4
        bgtu    a6,a3,.L34
.L37:
        divu    s4,a7,a4
        addi    a5,a5,1
        andi    a6,s4,0xff
        addi    s5,a6,55
        remu    a7,a7,a4
        addi    a6,a6,48
        div     a4,a4,t3
        ble     s4,a3,.L35
        sb      s5,-1(a5)
        bnez    a4,.L37
.L22:
        addi    a1,a1,2
        j       .L43
.L65:
        beq     a4,t2,.L19
        beq     a4,t0,.L20
        bne     a4,t1,.L22
        sb      t1,0(a5)
        addi    a1,a1,2
        addi    a5,a5,1
        j       .L43
.L67:
        bne     a4,s1,.L22
.L19:
        lw      s4,0(a2)
        li      a4,1
        addi    a2,a2,4
        bleu    s4,t6,.L49
.L39:
        slli    a4,a4,4
        divu    a6,s4,a4
        bgtu    a6,t6,.L39
.L42:
        andi    a7,a6,0xff
        addi    s5,a7,55
        remu    s4,s4,a4
        addi    a7,a7,48
        addi    a5,a5,1
        srai    a4,a4,4
        ble     a6,a3,.L40
.L68:
        sb      s5,-1(a5)
.L41:
        beqz    a4,.L22
        addi    a5,a5,1
        divu    a6,s4,a4
        andi    a7,a6,0xff
        addi    s5,a7,55
        remu    s4,s4,a4
        addi    a7,a7,48
        srai    a4,a4,4
        bgt     a6,a3,.L68
.L40:
        sb      a7,-1(a5)
        j       .L41
.L66:
        bne     a4,s0,.L22
.L17:
        lw      s4,0(a2)
        addi    a2,a2,4
        bltz    s4,.L69
.L26:
        mv      a7,s4
        li      a4,1
        ble     s4,a3,.L31
.L28:
        slli    a6,a4,2
        add     a4,a6,a4
        slli    a4,a4,1
        divu    a6,s4,a4
        bgtu    a6,a3,.L28
.L31:
        divu    s4,a7,a4
        addi    a5,a5,1
        andi    a6,s4,0xff
        addi    s5,a6,55
        remu    a7,a7,a4
        addi    a6,a6,48
        div     a4,a4,t3
        bleu    s4,a3,.L29
.L70:
        sb      s5,-1(a5)
        beqz    a4,.L22
.L63:
        addi    a5,a5,1
        divu    s4,a7,a4
        andi    a6,s4,0xff
        addi    s5,a6,55
        remu    a7,a7,a4
        addi    a6,a6,48
        div     a4,a4,t3
        bgtu    s4,a3,.L70
.L29:
        sb      a6,-1(a5)
        bnez    a4,.L63
        j       .L22
.L35:
        sb      a6,-1(a5)
        bnez    a4,.L37
        j       .L22
.L23:
        lw      a6,0(a2)
        addi    a2,a2,4
        lbu     a4,0(a6)
        beqz    a4,.L22
.L32:
        addi    a5,a5,1
        addi    a6,a6,1
        sb      a4,-1(a5)
        lbu     a4,0(a6)
        bnez    a4,.L32
        addi    a1,a1,2
        j       .L43
.L20:
        lw      a4,0(a2)
        addi    a5,a5,1
        addi    a2,a2,4
        sb      a4,-1(a5)
        addi    a1,a1,2
        j       .L43
.L69:
        sb      s3,0(a5)
        sub     s4,zero,s4
        addi    a5,a5,1
        j       .L26
.L45:
        sb      zero,0(a0)
        sub     a0,a0,a0
        ret
.L49:
        mv      a6,s4
        j       .L42
bufprintf:
        addi    sp,sp,-64
        addi    t1,sp,40
        sw      a2,40(sp)
        mv      a2,t1
        sw      ra,28(sp)
        sw      a3,44(sp)
        sw      a4,48(sp)
        sw      a5,52(sp)
        sw      a6,56(sp)
        sw      a7,60(sp)
        sw      t1,12(sp)
        call    bpf_formatstring
        lw      ra,28(sp)
        addi    sp,sp,64
        jr      ra