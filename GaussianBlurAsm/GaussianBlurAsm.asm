.code
BlurOneAsm PROC
;ix = 0 ; r10d
;x = 4
;iy = 8 ; r11d
;y = 12
;j = 16
;i = 20
;kernel = 24
;array = 64
;source = 96
;destination = 104
;width = 112
;height = 120
;offset = 128
Begin_blur:
        mov     DWORD PTR [rsp+32], r9d     ; can use this as a register, not a variable on stack, height
        mov     DWORD PTR [rsp+24], r8d     ; can use this as a register, not a variable on stack, width
        mov     QWORD PTR [rsp+16], rdx
        mov     QWORD PTR [rsp+8], rcx
        sub     rsp, 88 
        mov     QWORD PTR [rsp+64], rax     ; reserve spot for table
        mov     DWORD PTR [rsp+24], 1       ; put 1 on stack
        mov     DWORD PTR [rsp+28], 2       ; put 2 on stack
        mov     DWORD PTR [rsp+32], 1       ; put 1 on stack
        mov     DWORD PTR [rsp+36], 2       ; put 2 on stack
        mov     DWORD PTR [rsp+40], 4       ; put 4 on stack
        mov     DWORD PTR [rsp+44], 2       ; put 2 on stack
        mov     DWORD PTR [rsp+48], 1       ; put 1 on stack
        mov     DWORD PTR [rsp+52], 2       ; put 2 on stack
        mov     DWORD PTR [rsp+56], 1       ; put 1 on stack
        
        xorpd   xmm0, xmm0                  ; clear xmm0
        xorpd   xmm1, xmm1                  ; clear xmm1
        xorpd   xmm2, xmm2                  ; clear xmm2

        pinsrd  xmm0, DWORD PTR [rsp+24], 0 ; fill xmm0 with first row of a kernel
        pinsrd  xmm0, DWORD PTR [rsp+28], 1
        pinsrd  xmm0, DWORD PTR [rsp+32], 2
        pinsrd  xmm1, DWORD PTR [rsp+36], 0 ; fill xmm1 with second row of a kernel
        pinsrd  xmm1, DWORD PTR [rsp+40], 1
        pinsrd  xmm1, DWORD PTR [rsp+44], 2
        pinsrd  xmm2, DWORD PTR [rsp+48], 0 ; fill xmm2 with third row of a kernel
        pinsrd  xmm2, DWORD PTR [rsp+52], 1
        pinsrd  xmm2, DWORD PTR [rsp+56], 2

        mov     eax, DWORD PTR [rsp+128]    ; eax <- offset
        mov     DWORD PTR [rsp+20], eax     ; x <- eax
        jmp     SHORT Compare_i_load_j
Increment_i:
        mov     eax, DWORD PTR [rsp+20]     ; eax <- i
        inc     eax
        mov     DWORD PTR [rsp+20], eax
Compare_i_load_j:
        cmp     DWORD PTR [rsp+20], r9d     ; height == i
        jge     Finish
        mov     DWORD PTR [rsp+16], 0       ; j = 0
        jmp     SHORT Compare_j_load_loop
Increment_j:
        xorpd   xmm9, xmm9
        mov     eax, DWORD PTR [rsp+16]     ; eax <- j
        inc     eax                         ; eax++
        mov     DWORD PTR [rsp+16], eax     ; j <- eax
Compare_j_load_loop:
        cmp     DWORD PTR [rsp+16], r8d     ; j == width
        jge     Increment_i
        mov     eax, DWORD PTR [rsp+20]     ; eax <- i
        dec     eax                         ; eax--
        mov     r11d, eax                   ; ix <- i - 1
        mov     r10d, 0                     ; iy <- 0
        mov     DWORD PTR [rsp+12], 0       ; y <- 0
        mov     DWORD PTR [rsp+4], 0        ; x <- 0
        xorpd   xmm7, xmm7                  ; clear xmm7 for first row to be multipiled with kernel first row
        cmp     r11d, 0                     ; ix == 0
        jle     SHORT Y_height_mins_comparison_first      
        mov     DWORD PTR [rsp+12], r11d    ; y <- ix
Y_height_mins_comparison_first:
        mov     eax, r9d                    ; eax <- height
        dec     eax                         ; eax--
        cmp     eax, DWORD PTR [rsp+12]     ; height - 1 == iy
        jge     SHORT Ix_loop_beg_first
        mov     DWORD PTR [rsp+12], eax     ; iy <- height - 1
Ix_loop_beg_first:
        mov     eax, DWORD PTR [rsp+16]     ; eax <- j
        dec     eax                         ; j--
        mov     r10d, eax                   ; ix = j
        jmp     SHORT Compare_ix_load_loop_first
Increment_ix_first:
        inc     r10d                        ; ix++
Compare_ix_load_loop_first:
        mov     eax, DWORD PTR [rsp+16]     ; eax <- j
        add     eax, 2                      ; j + 2
        cmp     r10d, eax                   ; ix < j + 2
        jge     SHORT Increment_iy_first
        mov     DWORD PTR [rsp+4], 0        ; x = 0
        cmp     r10d, 0                     ; ix == 0
        jle     SHORT X_width_mins_comparison_first
        mov     DWORD PTR [rsp+4], r10d     ; x = ix
X_width_mins_comparison_first:
        mov     eax, r8d                    ; eax <- width
        dec     eax                         ; width--
        cmp     eax, DWORD PTR [rsp+4]      ; width - 1 == x
        jge     SHORT Add_to_first_vector
        mov     DWORD PTR [rsp+4], eax      ; x = width - 1
Add_to_first_vector:
        mov     eax, DWORD PTR[rsp+12]      ; eax <- y
        imul    eax, r8d                    ; y * width
        add     eax, DWORD PTR[rsp+4]       ; y * width + x - index of the source to be changed
        cdqe    
        mov     rcx, QWORD PTR[rsp+96]      ; rcx <- source
        movzx   eax, BYTE PTR[rcx+rax]      ; eax <- selected pixel value
        pinsrd  xmm7, eax, 3                ; move it to fourth position
        psrldq  xmm7, 4                     ; move it left so it makes place for the next value
        jmp     Increment_ix_first
Increment_iy_first:
        xorpd   xmm8, xmm8                  ; clear xmm8 for next use
        vpmulld  xmm8, xmm0, xmm7            ; multipy first row of kernel with first row of taken image part
        vpaddw   xmm9, xmm9, xmm8            ; add to sum in xmm9
        xorpd   xmm7, xmm7                  ; clear xmm7 for second row to be multipiled with kernel second row
        inc     r11d                        ; iy++
        cmp     r11d, 0                     ; iy == 0
        jle     SHORT Y_height_mins_comparison_second
        mov     DWORD PTR [rsp+12], r11d    ; y = iy
Y_height_mins_comparison_second:
        mov     eax, r9d                    ; eax <- height
        dec     eax                         ; height--
        cmp     eax, DWORD PTR [rsp+12]     ; height - 1 < y
        jge     SHORT Ix_loop_beg_second
        mov     DWORD PTR [rsp+12], eax     ; y = height - 1
Ix_loop_beg_second:
        mov     eax, DWORD PTR [rsp+16]     ; eax <- j
        dec     eax                         ; j--
        mov     r10d, eax                   ; ix = j - 1
        jmp     SHORT Compare_ix_load_loop_second
Increment_ix_second:
        inc     r10d                        ; ix++
Compare_ix_load_loop_second:
        mov     eax, DWORD PTR [rsp+16]     ; eax <- j
        add     eax, 2                      ; j + 2
        cmp     r10d, eax                   ; ix < j + 2
        jge     SHORT Increment_iy_second
        mov     DWORD PTR [rsp+4], 0        ; x = 0
        cmp     r10d, 0                     ; ix == 0
        jle     SHORT X_width_mins_comparison_second
        mov     DWORD PTR [rsp+4], r10d     ; x = ix
X_width_mins_comparison_second:
        mov     eax, r8d                    ; eax <- width
        dec     eax                         ; width--
        cmp     eax, DWORD PTR [rsp+4]      ; width - 1 < x
        jge     SHORT Add_to_second_vector
        mov     DWORD PTR [rsp+4], eax      ; x = width - 1
Add_to_second_vector:
        mov     eax, DWORD PTR[rsp+12]      ; eax <- y
        imul    eax, r8d                    ; y * width
        add     eax, DWORD PTR[rsp+4]       ; y * width + x - index of the source to be changed
        cdqe    
        mov     rcx, QWORD PTR[rsp+96]      ; rcx <- source
        movzx   eax, BYTE PTR[rcx+rax]      ; eax <- selected pixel value
        pinsrd  xmm7, eax, 3                ; move it to fourth position
        psrldq  xmm7, 4                     ; move it left so it makes place for the next value
        jmp     Increment_ix_second
Increment_iy_second:
        xorpd   xmm8, xmm8                  ; clear xmm8 for next use
        vpmulld xmm8, xmm1, xmm7             ; multipy second row of kernel with second row of taken image part
        vpaddw  xmm9, xmm9, xmm8            ; add to sum in xmm9
        xorpd   xmm7, xmm7                  ; clear xmm7 for third row to be multipiled with kernel third row
        inc     r11d                        ; iy++
        cmp     r11d, 0                     ; iy == 0
        jle     SHORT Y_height_mins_comparison_third
        mov     DWORD PTR [rsp+12], r11d    ; y = iy
Y_height_mins_comparison_third:
        mov     eax, r9d                    ; eax <- height
        dec     eax                         ; height--
        cmp     eax, DWORD PTR [rsp+12]     ; height - 1 < y
        jge     SHORT Ix_loop_beg_third
        mov     DWORD PTR [rsp+12], eax     ; y = height - 1
Ix_loop_beg_third:
        mov     eax, DWORD PTR [rsp+16]     ; eax <- j
        dec     eax                         ; j--
        mov     r10d, eax                   ; ix = j - 1
        jmp     SHORT Compare_ix_load_loop_third
Increment_ix_third:
        inc     r10d                        ; ix++
Compare_ix_load_loop_third:
        mov     eax, DWORD PTR [rsp+16]     ; eax <- j
        add     eax, 2                      ; j + 2
        cmp     r10d, eax                   ; ix < j + 2
        jge     Add_values_set_destination  ; there should be label for adding the values and setting the destination, from there to increment_j
        mov     DWORD PTR [rsp+4], 0        ; x = 0
        cmp     r10d, 0                     ; ix == 0
        jle     SHORT X_width_mins_comparison_third
        mov     DWORD PTR [rsp+4], r10d     ; x = ix
X_width_mins_comparison_third:
        mov     eax, r8d                    ; eax <- width
        dec     eax                         ; width--
        cmp     eax, DWORD PTR [rsp+4]      ; width - 1 < x
        jge     SHORT Add_to_third_vector
        mov     DWORD PTR [rsp+4], eax      ; x = width - 1
Add_to_third_vector:
        mov     eax, DWORD PTR[rsp+12]      ; eax <- y
        imul    eax, r8d                    ; y * width
        add     eax, DWORD PTR[rsp+4]       ; y * width + x - index of the source to be changed
        cdqe    
        mov     rcx, QWORD PTR[rsp+96]      ; rcx <- source
        movzx   eax, BYTE PTR[rcx+rax]      ; eax <- selected pixel value
        pinsrd  xmm7, eax, 3                ; move it to fourth position
        psrldq  xmm7, 4                     ; move it left so it makes place for the next value
        jmp     Increment_ix_third
Add_values_set_destination:
        xorpd   xmm8, xmm8                  ; clear xmm8 for next use
        vpmulld  xmm8, xmm2, xmm7             ; multipy second row of kernel with second row of taken image part
        vpaddw  xmm9, xmm9, xmm8            ; add to sum in xmm9
        xorpd   xmm7, xmm7                  ; clear xmm7 for third row to be multipiled with kernel third row
        haddpd  xmm9, xmm9                  ; add first to second and third to fourth (0)
        haddpd  xmm9, xmm9                  ; add firstSecond to thirdFourth
        pextrd  eax, xmm9, 0
        sar     eax, 4
        mov     ecx, DWORD PTR[rsp+20]      ; eax <- i
        imul    ecx, r8d                    ; i * width
        add     ecx, DWORD PTR[rsp+16]      ; i * width + j
        movsxd  rcx, ecx
        mov     rdx, QWORD PTR[rsp+104]
        mov     BYTE PTR[rdx+rcx], al
        jmp     Increment_j        
Finish:
        mov     rcx, QWORD PTR [rsp+64]
        add     rsp, 88
        ret     0
BlurOneAsm ENDP

END