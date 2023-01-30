.code
BlurOneAsm PROC
Begin_blur:
        mov     DWORD PTR [rsp+32], r9d     ; can use this as a register, not a variable on stack, height
        mov     DWORD PTR [rsp+24], r8d     ; can use this as a register, not a variable on stack, width
        mov     QWORD PTR [rsp+16], rdx     ; rsp+32, destination
        mov     QWORD PTR [rsp+8],  rcx     ; rsp+24, source
        mov     r12d, DWORD PTR [rsp+40]    ; eax <- offset
        push    r12
        push    r13
        push    r14
        push    r15
        xor     r12, r12
        xor     r13, r13
        xor     r14, r14
        xor     r15, r15
        ; x  - r12d
        ; y  - r13d
        ; j  - r14d
        ; i  - r15d
                                            ; ix - r10d
                                            ; iy - r11d
        xorpd   xmm0, xmm0                  ; clear xmm0
        xorpd   xmm1, xmm1                  ; clear xmm1
        xorpd   xmm2, xmm2                  ; clear xmm2

        mov     eax, 1                      ; element from kernel
        mov     ecx, 2                      ; element from kernel
        mov     edx, 4                      ; element from kernel

        pinsrd  xmm0, eax, 0                ; fill xmm0 with first row of a kernel
        pinsrd  xmm0, ecx, 1
        pinsrd  xmm0, eax, 2
        pinsrd  xmm1, ecx, 0                ; fill xmm1 with second row of a kernel
        pinsrd  xmm1, edx, 1
        pinsrd  xmm1, ecx, 2
        pinsrd  xmm2, eax, 0                ; fill xmm2 with third row of a kernel
        pinsrd  xmm2, ecx, 1
        pinsrd  xmm2, eax, 2

        jmp     SHORT Compare_i_load_j
Increment_i:
        inc     r15d
Compare_i_load_j:
        cmp     r15d, r9d                   ; height == i
        jge     Finish
        mov     r14d, 0                     ; j = 0
        jmp     SHORT Compare_j_load_loop
Increment_j:
        xorpd   xmm9, xmm9
        inc     r14d                        ; eax++
Compare_j_load_loop:
        cmp     r14d, r8d                   ; j == width
        jge     Increment_i
        mov     eax, r15d                   ; eax <- i
        dec     eax                         ; eax--
        mov     r11d, eax                   ; ix <- i - 1
        mov     r10d, 0                     ; iy <- 0
        mov     r13d, 0                     ; y <- 0
        mov     r12d, 0                     ; x <- 0
        xorpd   xmm7, xmm7                  ; clear xmm7 for first row to be multipiled with kernel first row
        cmp     r11d, 0                     ; ix == 0
        jle     SHORT Y_height_mins_comparison_first      
        mov     r13d, r11d                  ; y <- ix
Y_height_mins_comparison_first:
        mov     eax, r9d                    ; eax <- height
        dec     eax                         ; eax--
        cmp     eax, r11d                   ; height - 1 == iy
        jge     SHORT Ix_loop_beg_first
        mov     r11d, eax                   ; iy <- height - 1
Ix_loop_beg_first:
        mov     eax, r14d                   ; eax <- j
        dec     eax                         ; j--
        mov     r10d, eax                   ; ix = j - 1
        jmp     SHORT Compare_ix_load_loop_first
Increment_ix_first:
        inc     r10d                        ; ix++
Compare_ix_load_loop_first:
        mov     eax, r14d                   ; eax <- j
        add     eax, 2                      ; j + 2
        cmp     r10d, eax                   ; ix < j + 2
        jge     SHORT Increment_iy_first
        mov     r12d, 0                     ; x = 0
        cmp     r10d, 0                     ; ix == 0
        jle     SHORT X_width_mins_comparison_first
        mov     r12d, r10d                  ; x = ix
X_width_mins_comparison_first:
        mov     eax, r8d                    ; eax <- width
        dec     eax                         ; width--
        cmp     eax, r12d                   ; width - 1 == x
        jge     SHORT Add_to_first_vector
        mov     r12d, eax                   ; x = width - 1
Add_to_first_vector:
        mov     eax, r13d                   ; eax <- y
        imul    eax, r8d                    ; y * width
        add     eax, r12d                   ; y * width + x - index of the source to be changed
        cdqe    
        mov     rcx, QWORD PTR[rsp+40]      ; rcx <- source
        movzx   eax, BYTE PTR[rcx+rax]      ; eax <- selected pixel value
        pinsrd  xmm7, eax, 3                ; move it to fourth position
        psrldq  xmm7, 4                     ; move it left so it makes place for the next value
        jmp     Increment_ix_first
Increment_iy_first:
        xorpd   xmm8, xmm8                  ; clear xmm8 for next use
        vpmulld  xmm8, xmm0, xmm7           ; multipy first row of kernel with first row of taken image part
        vpaddw   xmm9, xmm9, xmm8           ; add to sum in xmm9
        xorpd   xmm7, xmm7                  ; clear xmm7 for second row to be multipiled with kernel second row
        inc     r11d                        ; iy++
        cmp     r11d, 0                     ; iy == 0
        jle     SHORT Y_height_mins_comparison_second
        mov     r13d, r11d                  ; y = iy
Y_height_mins_comparison_second:
        mov     eax, r9d                    ; eax <- height
        dec     eax                         ; height--
        cmp     eax, r13d                   ; height - 1 < y
        jge     SHORT Ix_loop_beg_second
        mov     r13d, eax                   ; y = height - 1
Ix_loop_beg_second:
        mov     eax, r14d                   ; eax <- j
        dec     eax                         ; j--
        mov     r10d, eax                   ; ix = j - 1
        jmp     SHORT Compare_ix_load_loop_second
Increment_ix_second:
        inc     r10d                        ; ix++
Compare_ix_load_loop_second:
        mov     eax, r14d                   ; eax <- j
        add     eax, 2                      ; j + 2
        cmp     r10d, eax                   ; ix < j + 2
        jge     SHORT Increment_iy_second
        mov     r12d, 0                     ; x = 0
        cmp     r10d, 0                     ; ix == 0
        jle     SHORT X_width_mins_comparison_second
        mov     r12d, r10d                  ; x = ix
X_width_mins_comparison_second:
        mov     eax, r8d                    ; eax <- width
        dec     eax                         ; width--
        cmp     eax, r12d                   ; width - 1 < x
        jge     SHORT Add_to_second_vector
        mov     r12d, eax                   ; x = width - 1
Add_to_second_vector:
        mov     eax, r13d                   ; eax <- y
        imul    eax, r8d                    ; y * width
        add     eax, r12d                   ; y * width + x - index of the source to be changed
        cdqe    
        mov     rcx, QWORD PTR[rsp+40]      ; rcx <- source
        movzx   eax, BYTE PTR[rcx+rax]      ; eax <- selected pixel value
        pinsrd  xmm7, eax, 3                ; move it to fourth position
        psrldq  xmm7, 4                     ; move it left so it makes place for the next value
        jmp     Increment_ix_second
Increment_iy_second:
        xorpd   xmm8, xmm8                  ; clear xmm8 for next use
        vpmulld xmm8, xmm1, xmm7            ; multipy second row of kernel with second row of taken image part
        vpaddw  xmm9, xmm9, xmm8            ; add to sum in xmm9
        xorpd   xmm7, xmm7                  ; clear xmm7 for third row to be multipiled with kernel third row
        inc     r11d                        ; iy++
        cmp     r11d, 0                     ; iy == 0
        jle     SHORT Y_height_mins_comparison_third
        mov     r13d, r11d                  ; y = iy
Y_height_mins_comparison_third:
        mov     eax, r9d                    ; eax <- height
        dec     eax                         ; height--
        cmp     eax, r13d                   ; height - 1 < y
        jge     SHORT Ix_loop_beg_third
        mov     r13d, eax                   ; y = height - 1
Ix_loop_beg_third:
        mov     eax, r14d                   ; eax <- j
        dec     eax                         ; j--
        mov     r10d, eax                   ; ix = j - 1
        jmp     SHORT Compare_ix_load_loop_third
Increment_ix_third:
        inc     r10d                        ; ix++
Compare_ix_load_loop_third:
        mov     eax, r14d                   ; eax <- j
        add     eax, 2                      ; j + 2
        cmp     r10d, eax                   ; ix < j + 2
        jge     Add_values_set_destination  ; there should be label for adding the values and setting the destination, from there to increment_j
        mov     r12d, 0                     ; x = 0
        cmp     r10d, 0                     ; ix == 0
        jle     SHORT X_width_mins_comparison_third
        mov     r12d, r10d                  ; x = ix
X_width_mins_comparison_third:
        mov     eax, r8d                    ; eax <- width
        dec     eax                         ; width--
        cmp     eax, r12d                   ; width - 1 < x
        jge     SHORT Add_to_third_vector
        mov     r12d, eax                   ; x = width - 1
Add_to_third_vector:
        mov     eax, r13d                   ; eax <- y
        imul    eax, r8d                    ; y * width
        add     eax, r12d                   ; y * width + x - index of the source to be changed
        cdqe    
        mov     rcx, QWORD PTR[rsp+40]      ; rcx <- source
        movzx   eax, BYTE PTR[rcx+rax]      ; eax <- selected pixel value
        pinsrd  xmm7, eax, 3                ; move it to fourth position
        psrldq  xmm7, 4                     ; move it left so it makes place for the next value
        jmp     Increment_ix_third
Add_values_set_destination:
        xorpd   xmm8, xmm8                  ; clear xmm8 for next use
        vpmulld  xmm8, xmm2, xmm7           ; multipy second row of kernel with second row of taken image part
        vpaddw  xmm9, xmm9, xmm8            ; add to sum in xmm9
        xorpd   xmm7, xmm7                  ; clear xmm7 for third row to be multipiled with kernel third row
        haddpd  xmm9, xmm9                  ; add first to second and third to fourth (0)
        haddpd  xmm9, xmm9                  ; add firstSecond to thirdFourth
        pextrd  eax, xmm9, 0
        sar     eax, 4
        mov     ecx, r15d                   ; eax <- i
        imul    ecx, r8d                    ; i * width
        add     ecx, r14d                   ; i * width + j
        movsxd  rcx, ecx
        mov     rdx, QWORD PTR[rsp+48]
        mov     BYTE PTR[rdx+rcx], al
        jmp     Increment_j        
Finish:
        pop    r15
        pop    r14
        pop    r13
        pop    r12
        ret     0
BlurOneAsm ENDP

END