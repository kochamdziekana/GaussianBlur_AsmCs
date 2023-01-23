.code
BlurOneAsm PROC               ; BlurTarget
LN19:
        mov     DWORD PTR [rsp+32], r9d
        mov     DWORD PTR [rsp+24], r8d
        mov     QWORD PTR [rsp+16], rdx
        mov     QWORD PTR [rsp+8], rcx
        sub     rsp, 88
        xor     rax, rsp
        mov     QWORD PTR [rsp+72], rax
        mov     DWORD PTR [rsp+32], 1
        mov     DWORD PTR [rsp+36], 2
        mov     DWORD PTR [rsp+40], 1
        mov     DWORD PTR [rsp+44], 2
        mov     DWORD PTR [rsp+48], 4
        mov     DWORD PTR [rsp+52], 2
        mov     DWORD PTR [rsp+56], 1
        mov     DWORD PTR [rsp+60], 2
        mov     DWORD PTR [rsp+64], 1
        mov     eax, DWORD PTR [rsp+128]
        mov     DWORD PTR [rsp], eax
        jmp     SHORT LN4
LN2:
        mov     eax, DWORD PTR [rsp]
        inc     eax
        mov     DWORD PTR [rsp], eax
LN4:
        mov     eax, DWORD PTR [rsp+120]
        cmp     DWORD PTR [rsp], eax
        jge     LN3
        mov     DWORD PTR [rsp+4], 0
        jmp     SHORT LN7
LN5:
        mov     eax, DWORD PTR [rsp+4]
        inc     eax
        mov     DWORD PTR [rsp+4], eax
LN7:
        mov     eax, DWORD PTR [rsp+112]
        cmp     DWORD PTR [rsp+4], eax
        jge     LN6
        xorps   xmm0, xmm0
        movsd   QWORD PTR [rsp+24], xmm0
        mov     eax, DWORD PTR [rsp]
        dec     eax
        mov     DWORD PTR [rsp+16], eax
        jmp     SHORT LN10
LN8:
        mov     eax, DWORD PTR [rsp+16]
        inc     eax
        mov     DWORD PTR [rsp+12], eax
LN10:
        mov     eax, DWORD PTR [rsp]
        add     eax, 2
        cmp     DWORD PTR [rsp+12], eax
        jge     LN9
        mov     eax, DWORD PTR [rsp+4]
        dec     eax
        mov     DWORD PTR [rsp+8], eax
        jmp     SHORT LN13
LN11:
        mov     eax, DWORD PTR [rsp+8]
        inc     eax
        mov     DWORD PTR [rsp+8], eax
LN13:
        mov     eax, DWORD PTR [rsp+4]
        add     eax, 2
        cmp     DWORD PTR [rsp+8], eax
        jge     LN12
        mov     DWORD PTR [rsp+20], 0
        cmp     DWORD PTR [rsp+8], 0
        jle     SHORT LN14
        mov     eax, DWORD PTR [rsp+8]
        mov     DWORD PTR [rsp+20], eax
LN14:
        mov     eax, DWORD PTR [rsp+112]
        dec     eax
        cmp     eax, DWORD PTR [rsp+20]
        jge     SHORT LN15
        mov     eax, DWORD PTR [rsp+112]
        dec     eax
        mov     DWORD PTR [rsp+20], eax
LN15:
        mov     DWORD PTR [rsp+16], 0
        cmp     DWORD PTR [rsp+12], 0
        jle     SHORT LN16
        mov     eax, DWORD PTR [rsp+12]
        mov     DWORD PTR [rsp+16], eax
LN16:
        mov     eax, DWORD PTR [rsp+120]
        dec     eax
        cmp     eax, DWORD PTR [rsp+16]
        jge     SHORT LN17
        mov     eax, DWORD PTR [rsp+120]
        dec     eax
        mov     DWORD PTR [rsp+16], eax
LN17:
        mov     eax, DWORD PTR [rsp+16]
        imul    eax, DWORD PTR [rsp+112]
        add     eax, DWORD PTR [rsp+20]
        cdqe
        mov     rcx, QWORD PTR [rsp+96]
        movzx   eax, BYTE PTR [rcx+rax]
        mov     ecx, DWORD PTR [rsp+4]
        mov     edx, DWORD PTR [rsp+8]
        sub     edx, ecx
        mov     ecx, edx
        inc     ecx
        movsxd  rcx, ecx
        imul    rcx, rcx, 12
        lea     rcx, QWORD PTR [rsp+32+rcx]
        mov     edx, DWORD PTR [rsp]
        mov     r8d, DWORD PTR [rsp+12]
        sub     r8d, edx
        mov     edx, r8d
        inc     edx
        movsxd  rdx, edx
        imul    eax, DWORD PTR [rcx+rdx*4]
        cvtsi2sd xmm0, eax
        movsd   xmm1, QWORD PTR [rsp+24]
        addsd   xmm1, xmm0
        movaps  xmm0, xmm1
        movsd   QWORD PTR [rsp+24], xmm0
        jmp     LN11
LN12:
        jmp     LN8
LN9:
        cvttsd2si rax, QWORD PTR [rsp+24]
        sar     rax, 4
        mov     ecx, DWORD PTR [rsp]
        imul    ecx, DWORD PTR [rsp+112]
        add     ecx, DWORD PTR [rsp+4]
        movsxd  rcx, ecx
        mov     rdx, QWORD PTR [rsp+104]
        mov     BYTE PTR [rdx+rcx], al
        jmp     LN5
LN6:
        jmp     LN2
LN3:
        mov     rcx, QWORD PTR [rsp+72]
        xor     rcx, rsp
        add     rsp, 88         
        ret 
BlurOneAsm ENDP                ; BlurTarget

END