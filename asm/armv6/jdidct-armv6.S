        .syntax unified
        .arch   armv6t2

        .text

        .global idct_8x8_armv6
idct_8x8_armv6:
        push            {r1-r11,lr}
        sub             sp,  sp,  #132
        mov             lr,  #64
        mov             r1,  #0
        mov             r2,  #0
        mov             r10, #0
        movs            r11, #0
1:
        ldrd            r8,  r9,  [r0]
        ldrd            r4,  r5,  [r3], #8
        smulbb          r6,  r8,  r4
        smultt          r8,  r8,  r4
        smulbb          r7,  r9,  r5
        smultt          r9,  r9,  r5
        ldrd            r4,  r5,  [r3], #8
        pkhbt           r6,  r6,  r8,  lsl #16
        pkhbt           r7,  r7,  r9,  lsl #16
        ldrd            r8,  r9,  [r0, #8]!
        itt             ne
        orrne           r2,  r2,  r6
        orrne           r1,  r1,  r7
        strd            r6,  r7,  [r0, #-8]
        smulbb          r6,  r8,  r4
        smultt          r8,  r8,  r4
        smulbb          r7,  r9,  r5
        smultt          r9,  r9,  r5
        pkhbt           r6,  r6,  r8,  lsl #16
        pkhbt           r7,  r7,  r9,  lsl #16
        itt             ne
        orrne           r10, r10, r6
        orrne           r11, r11, r7
        subs            lr,  lr,  #8
        strd            r6,  r7,  [r0], #8
        bgt             1b

        mov             r3,  #0
        tst             r2,  r2
        it              ne
        orrne           r3,  r3,  #8
        tst             r1,  r1
        it              ne
        orrne           r3,  r3,  #4
        tst             r10, r10
        it              ne
        orrne           r3,  r3,  #2
        tst             r11, r11
        it              ne
        orrne           r3,  r3,  #1

        sub             r0,  r0,  #128
        str             r3,  [sp, #140]
        mov             r11, #8
        str             r11, [sp, #128]
        mov             r1,  sp
        teq             r11, r11
        mov             r12, #1024

.LoopRowTrans:
        ldr             lr,  =0x5a82
        ldr             r4,  [r0], #4
        ldr             r11, [sp, #128]
        ldr             r3,  [sp, #140]
        it              eq
        sadd16eq        r4,  r4,  r12
        tst             r11, r3
        mov             r12, #8192
        beq             .Lrowdc
        ldr             r5,  [r0, #12]
        ldr             r6,  [r0, #108]
        ldr             r7,  [r0, #44]
        ssub16          r9,  r5,  r6
        ldr             r8,  [r0, #76]
        sadd16          r5,  r5,  r6
        smlatb          r6,  r7,  lr,  r12
        smlabb          r7,  r7,  lr,  r12
        lsl             r6,  r6,  #2
        lsrs            r11, r11, #1
        pkhtb           r6,  r6,  r7,  asr #14
        smlatb          r7,  r8,  lr,  r12
        smlabb          r8,  r8,  lr,  r12
        lsl             r7,  r7,  #2
        str             r11, [sp, #128]
        pkhtb           r7,  r7,  r8,  asr #14
        ldr             r8,  [r0, #60]
        ssub16          r10, r5,  r6
        sadd16          r5,  r5,  r6
        ldr             lr,  =0x539f22a3
        sadd16          r6,  r9,  r7
        ldr             r3,  [r0, #92]
        ssub16          r9,  r9,  r7
        ldr             r7,  [r0, #28]
        sadd16          r11, r4,  r8
        ssub16          r4,  r4,  r8
        pkhtb           r8,  r3,  r7,  asr #16
        pkhbt           r2,  r7,  r3,  lsl #16
        smlsd           r3,  r8,  lr,  r12
        smlsd           r7,  r2,  lr,  r12
        lsl             r3,  r3,  #2
        smladx          r2,  r2,  lr,  r12
        pkhtb           r3,  r3,  r7,  asr #14
        smladx          r7,  r8,  lr,  r12
        ldr             lr,  =0x238e3537
        lsl             r7,  r7,  #2
        ssub16          r8,  r4,  r3
        pkhtb           r7,  r7,  r2,  asr #14
        sadd16          r4,  r4,  r3
        sadd16          r3,  r11, r7
        ssub16          r2,  r11, r7
        pkhtb           r11, r5,  r6,  asr #16
        pkhbt           r7,  r6,  r5,  lsl #16
        smlsd           r5,  r11, lr,  r12
        smlsd           r6,  r7,  lr,  r12
        lsl             r5,  r5,  #2
        smladx          r7,  r7,  lr,  r12
        pkhtb           r5,  r5,  r6,  asr #14
        smladx          r6,  r11, lr,  r12
        ldr             lr,  =0x0c7c3ec5
        lsl             r6,  r6,  #2
        pkhbt           r11, r10, r9,  lsl #16
        pkhtb           r6,  r6,  r7,  asr #14
        pkhtb           r7,  r9,  r10, asr #16
        smlsd           r9,  r7,  lr,  r12
        smlsd           r10, r11, lr,  r12
        lsl             r9,  r9,  #2
        smladx          r11, r11, lr,  r12
        pkhtb           r9,  r9,  r10, asr #14
        smladx          r10, r7,  lr,  r12
        sadd16          r7,  r3,  r6
        lsl             r10, r10, #2
        ssub16          r3,  r3,  r6
        pkhtb           r10, r10, r11, asr #14
        sadd16          lr,  r8,  r9
        ssub16          r8,  r8,  r9
        sadd16          r9,  r2,  r5
        ssub16          r2,  r2,  r5
        sadd16          r5,  r4,  r10
        ssub16          r6,  r4,  r10
        pkhbt           r10, r2,  r8,  lsl #16
        pkhtb           r2,  r8,  r2,  asr #16
        pkhbt           r4,  r7,  r5,  lsl #16
        pkhtb           r8,  r5,  r7,  asr #16
        pkhbt           r5,  lr,  r9,  lsl #16
        pkhtb           r9,  r9,  lr,  asr #16
        pkhbt           r11, r6,  r3,  lsl #16
        pkhtb           r3,  r3,  r6,  asr #16
        strd            r4,  r5,  [r1], #8
        strd            r10, r11, [r1], #8
        strd            r8,  r9,  [r1], #8
        strd            r2,  r3,  [r1], #8
        bgt             .LoopRowTrans

.Lpass2:
        mov             r11, #4
        ldr             r1,  [sp, #132]
        mov             r0,  sp
        str             r11, [sp, #128]

.LoopColTrans:
        ldr             r4,  [r0], #4
        ldr             r5,  [r0, #12]
        ldr             lr,  =0x5a82
        ldr             r6,  [r0, #108]
        mov             r12, #16384
        ldr             r7,  [r0, #44]
        ldr             r8,  [r0, #76]
        shsub16         r9,  r5,  r6
        shadd16         r5,  r5,  r6
        ldr             r11, [sp, #128]
        smlatb          r6,  r7,  lr,  r12
        smlabb          r7,  r7,  lr,  r12
        lsl             r6,  r6,  #1
        subs            r11, r11, #1
        pkhtb           r6,  r6,  r7,  asr #15
        smlatb          r7,  r8,  lr,  r12
        smlabb          r8,  r8,  lr,  r12
        lsl             r7,  r7,  #1
        str             r11, [sp, #128]
        pkhtb           r7,  r7,  r8,  asr #15
        ldr             r8,  [r0, #60]
        ssub16          r10, r5,  r6
        sadd16          r5,  r5,  r6
        ldr             lr,  =0x539f22a3
        sadd16          r6,  r9,  r7
        ldr             r3,  [r0, #92]
        ssub16          r9,  r9,  r7
        ldr             r7,  [r0, #28]
        shadd16         r11, r4,  r8
        shsub16         r4,  r4,  r8
        pkhtb           r8,  r3,  r7,  asr #16
        pkhbt           r2,  r7,  r3,  lsl #16
        smlsd           r3,  r8,  lr,  r12
        smlsd           r7,  r2,  lr,  r12
        lsl             r3,  r3,  #1
        smladx          r2,  r2,  lr,  r12
        pkhtb           r3,  r3,  r7,  asr #15
        smladx          r7,  r8,  lr,  r12
        ldr             lr,  =0x238e3537
        lsl             r7,  r7,  #1
        shsub16         r8,  r4,  r3
        pkhtb           r7,  r7,  r2,  asr #15
        shadd16         r4,  r4,  r3
        shadd16         r3,  r11, r7
        shsub16         r2,  r11, r7
        pkhtb           r11, r5,  r6,  asr #16
        pkhbt           r7,  r6,  r5,  lsl #16
        smlsd           r5,  r11, lr,  r12
        smlsd           r6,  r7,  lr,  r12
        lsl             r5,  r5,  #1
        smladx          r7,  r7,  lr,  r12
        pkhtb           r5,  r5,  r6,  asr #15
        smladx          r6,  r11, lr,  r12
        ldr             lr,  =0x0c7c3ec5
        lsl             r6,  r6,  #1
        pkhbt           r11, r10, r9,  lsl #16
        pkhtb           r6,  r6,  r7,  asr #15
        pkhtb           r7,  r9,  r10, asr #16
        smlsd           r9,  r7,  lr,  r12
        smlsd           r10, r11, lr,  r12
        lsl             r9,  r9,  #1
        smladx          r11, r11, lr,  r12
        pkhtb           r9,  r9,  r10, asr #15
        smladx          r10, r7,  lr,  r12
        shadd16         r7,  r3,  r6
        lsl             r10, r10, #1
        shsub16         r3,  r3,  r6
        pkhtb           r10, r10, r11, asr #15
        usat16          r7,  #8,  r7
        shadd16         r6,  r4,  r10
        shsub16         r4,  r4,  r10
        shadd16         r10, r8,  r9
        shsub16         r8,  r8,  r9
        shadd16         r9,  r2,  r5
        shsub16         r2,  r2,  r5
        usat16          r6,  #8,  r6
        usat16          r10, #8,  r10
        usat16          r9,  #8,  r9
        usat16          r2,  #8,  r2
        usat16          r8,  #8,  r8
        usat16          r4,  #8,  r4
        usat16          r3,  #8,  r3
        pkhbt           r5,  r7,  r10, lsl #16
        pkhtb           r7,  r10, r7,  asr #16
        pkhbt           r10, r6,  r9,  lsl #16
        pkhtb           r9,  r9,  r6,  asr #16
        pkhbt           r11, r2,  r4,  lsl #16
        pkhtb           r2,  r4,  r2,  asr #16
        pkhbt           lr,  r8,  r3,  lsl #16
        pkhtb           r8,  r3,  r8,  asr #16
        orr             r10, r5,  r10, lsl #8
        orr             r11, r11, lr,  lsl #8
        orr             r6,  r7,  r9,  lsl #8
        orr             r7,  r2,  r8,  lsl #8
        ldr             r2,  [sp, #136]
        ldr             r3,  [r1], #4
        add             r3,  r3,  r2
        strd            r10, r11, [r3]
        ldr             r3,  [r1], #4
        add             r3,  r3,  r2
        strd            r6,  r7,  [r3]
        bgt             .LoopColTrans

        add             sp,  sp,  #144
        pop             {r4-r11,pc}

.Lrowdc:
        uxth            r6,  r4
        lsr             r4,  r4,  #16
        orr             r6,  r6,  r6,  lsl #16
        lsrs            r11, r11, #1
        mov             r7,  r6
        strd            r6,  r7,  [r1], #8
        orr             r4,  r4,  r4,  lsl #16
        strd            r6,  r7,  [r1], #8
        mov             r5,  r4
        strd            r4,  r5,  [r1], #8
        strd            r4,  r5,  [r1], #8
        str             r11, [sp, #128]
        bne             .LoopRowTrans
        b               .Lpass2
