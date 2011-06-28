        .syntax unified
        .arch   armv6t2

        .text

        .global yuvp2rgb888_armv6
yuvp2rgb888_armv6:
        mov             r12, #0
        push            {r4-r12,lr}
        ldr             r12, = -88<<16 | (-183 & 0xffff)
        ldr             lr,  =-359<<16 | (-454 & 0xffff)
1:
        ldr             r4,  [r0], #4
        ldr             r5,  [r1], #4
        ldr             r6,  [r2], #4
2:
        uxtb            r8,  r5                         @ r9  = u
        uxtb            r9,  r6                         @ r8  = v
        uxtb            r7,  r4                         @ r7  = y
        orr             r8,  r9,  r8,  lsl #16          @ r8  = u | v
        mov             r9,  #34816                     @ r9  = g_bias
        mov             r10, #45824                     @ r10 = r_bias
        smlad           r9,  r8,  r12, r9
        movw            r11, #57984
        smlabt          r10, r8,  lr,  r10
        lsr             r4,  r4,  #8
        smlatb          r11, r8,  lr,  r11
        lsr             r5,  r5,  #8
        add             r9,  r7,  r9,  asr #8
        sub             r10, r7,  r10, asr #8
        usat            r9,  #8,  r9
        sub             r11, r7,  r11, asr #8
        ldr             r8,  [sp, #32]
        usat            r10, #8,  r10
        ldr             r7,  [sp, #40]
        usat            r11, #8,  r11
        strb            r10, [r3], #1
        lsr             r6,  r6,  #8
        strb            r9,  [r3], #1
        add             r8,  r8,  #1
        strb            r11, [r3], #1
        cmp             r8,  r7
        popeq           {r4-r12,pc}
        tst             r8,  #3
        str             r8,  [sp, #32]
        bne             2b
        b               1b

        .global yyuvp2rgb888_armv6
yyuvp2rgb888_armv6:
        push            {r4-r11,lr}

1:
        ldr             r5,  [r1], #4
        ldr             r6,  [r2], #4
  .rept 2
        ldr             r4,  [r0], #4
    .rept 2
        uxtb            r8,  r5                         @ r9  = u
        ldr             r12, = -88<<16 | (-183 & 0xffff)
        uxtb            r9,  r6                         @ r8  = v
        ldr             lr,  =-359<<16 | (-454 & 0xffff)
        uxtb            r7,  r4                         @ r7  = y
        orr             r8,  r9,  r8,  lsl #16          @ r8  = u | v
        mov             r9,  #34816                     @ r9  = g_bias
        mov             r10, #45824                     @ r10 = r_bias
        smlad           r9,  r8,  r12, r9
        lsr             r5,  r5,  #8
        smlabt          r10, r8,  lr,  r10
        movw            r12, #57984
        smlatb          r11, r8,  lr,  r12
        lsr             r6,  r6,  #8
        add             r12, r7,  r9,  asr #8
        sub             lr,  r7,  r10, asr #8
        sub             r8,  r7,  r11, asr #8
        uxtb            r7,  r4,  ror #8                @ r7  = y
        usat            r12, #8,  r12
        usat            lr,  #8,  lr
        usat            r8,  #8,  r8
        add             r9,  r7,  r9,  asr #8
        strb            lr,  [r3], #1
        sub             r10, r7,  r10, asr #8
        strb            r12, [r3], #1
        usat            r9,  #8,  r9
        strb            r8,  [r3], #1
        sub             r11, r7,  r11, asr #8
        usat            r10, #8,  r10
        usat            r11, #8,  r11
        strb            r10, [r3], #1
        lsr             r4,  r4,  #16
        strb            r9,  [r3], #1
        strb            r11, [r3], #1
    .endr
  .endr

        ldr             r4,  [sp, #36]
        subs            r4,  r4,  #8
        str             r4,  [sp, #36]
        bgt             1b

        pop             {r4-r11,pc}
