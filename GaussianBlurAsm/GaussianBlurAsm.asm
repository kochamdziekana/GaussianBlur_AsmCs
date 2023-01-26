.code
BlurOneAsm PROC               ; BlurTarget
Begin_blur:
        mov     DWORD PTR [rsp+32], r9d     ; od³o¿enie wysokoœci na stos
        mov     DWORD PTR [rsp+24], r8d     ; od³o¿enie szerokoœci na stos
        mov     QWORD PTR [rsp+16], rdx     ; od³o¿enie wskaŸnika na tablicê docelow¹ (obraz wynikowy)
        mov     QWORD PTR [rsp+8], rcx      ; od³o¿enie wskaŸnika na tablicê Ÿród³ow¹ (obraz Ÿród³owy)
        sub     rsp, 88                     ; zarezerwowanie pamiêci na stosie
        mov     QWORD PTR [rsp+72], rax     ; reserve place for the last spot of the table
        mov     DWORD PTR [rsp+32], 1       ; set kernel value on stack
        mov     DWORD PTR [rsp+36], 2       ; set kernel value on stack
        mov     DWORD PTR [rsp+40], 1       ; set kernel value on stack
        mov     DWORD PTR [rsp+44], 2       ; set kernel value on stack
        mov     DWORD PTR [rsp+48], 4       ; set kernel value on stack
        mov     DWORD PTR [rsp+52], 2       ; set kernel value on stack
        mov     DWORD PTR [rsp+56], 1       ; set kernel value on stack
        mov     DWORD PTR [rsp+60], 2       ; set kernel value on stack
        mov     DWORD PTR [rsp+64], 1       ; set kernel value on stack
        mov     eax, DWORD PTR [rsp+128]    ; eax <- offset
        mov     DWORD PTR [rsp], eax        
        jmp     SHORT Compare_i_loop
Increment_i_loop:
        mov     eax, DWORD PTR [rsp]        ; eax int i = offset; i < height; i++)
        inc     eax                         ; increment i i++
        mov     DWORD PTR [rsp], eax        ; load incremented on stack
Compare_i_loop:
        mov     eax, r9d    ; eax <- height
        cmp     DWORD PTR [rsp], eax        ; height == i
        jge     Finish                      ; if height > i -> go to end
        mov     DWORD PTR [rsp+4], 0        ; j = 0
        jmp     SHORT Compare_j_loop        ; go to loop with j - width comparison
Increment_j:
        mov     eax, DWORD PTR [rsp+4]
        inc     eax
        mov     DWORD PTR [rsp+4], eax
Compare_j_loop:
        mov     eax, DWORD PTR [rsp+112]    ; eax <- width
        cmp     DWORD PTR [rsp+4], eax      ; j == width
        jge     Increment_i_loop            ; if width > j ->
        xorps   xmm0, xmm0                  ; clear xmm0
        movsd   QWORD PTR [rsp+24], xmm0    ; set value 0 on stack (sum of values of pixels = 0 on start)
        mov     eax, DWORD PTR [rsp]        ; iy = i
        dec     eax                         ; iy -= 1
        mov     DWORD PTR [rsp+12], eax     ; put iy on stack
        jmp     SHORT Compare_iy_loop
Increment_iy:
        mov     eax, DWORD PTR [rsp+12]     ; eax <- iy
        inc     eax ; iy++
        mov     DWORD PTR [rsp+12], eax     ; iy <- eax
Compare_iy_loop:
        mov     eax, DWORD PTR [rsp]        ; eax <- i
        add     eax, 2 ; i += 2
        cmp     DWORD PTR [rsp+12], eax     ; iy == i 
        jge     Set_pixel_value             ; if iy < i + 2 -> add value divided by 
        mov     eax, DWORD PTR [rsp+4]      ; eax <- j
        dec     eax                         ; j--
        mov     DWORD PTR [rsp+8], eax      ; ix <- eax
        jmp     SHORT Min_max_x_ix
Increment_ix:
        mov     eax, DWORD PTR [rsp+8]      ; eax <- ix
        inc     eax                         ; ix++
        mov     DWORD PTR [rsp+8], eax      ; ix <- eax
Min_max_x_ix:
        mov     eax, DWORD PTR [rsp+4]      ; eax <- j
        add     eax, 2                      ; j += 2
        cmp     DWORD PTR [rsp+8], eax      ; ix == j
        jge     Increment_iy
        mov     DWORD PTR [rsp+20], 0       ; x = 0
        cmp     DWORD PTR [rsp+8], 0        ; ix == 0
        jle     SHORT Compare_x_width
        mov     eax, DWORD PTR [rsp+8]      ; eax <- ix
        mov     DWORD PTR [rsp+20], eax     ; x <- eax
Compare_x_width:
        mov     eax, DWORD PTR [rsp+112]    ; eax <- width
        dec     eax                         ; width--
        cmp     eax, DWORD PTR [rsp+20]     ; x == width
        jge     SHORT Min_max_y_iy
        mov     DWORD PTR [rsp+20], eax     ; x = width
Min_max_y_iy:
        mov     DWORD PTR [rsp+16], 0       ; int y = 0
        cmp     DWORD PTR [rsp+12], 0       ; iy > 0
        jle     SHORT Compare_y_height
        mov     eax, DWORD PTR [rsp+12]     ; eax <- iy
        mov     DWORD PTR [rsp+16], eax     ; y <- iy
Compare_y_height:
        mov     eax, r9d                    ; eax <- height
        dec     eax                         ; height--
        cmp     eax, DWORD PTR [rsp+16]     ; y == height
        jge     SHORT Add_to_sum_of_values
        mov     DWORD PTR [rsp+16], eax     ; y = height
Add_to_sum_of_values:
        mov     eax, DWORD PTR [rsp+16]     ; eax <- y
        imul    eax, DWORD PTR [rsp+112]    ; eax <- y * width
        add     eax, DWORD PTR [rsp+20]     ; eax + x
        cdqe                                ; convert to qword
        mov     rcx, QWORD PTR [rsp+96]     ; rcx <- source table ptr
        movzx   eax, BYTE PTR [rcx+rax]     ; eax <- dword (from byte
        mov     ecx, DWORD PTR [rsp+4]      ; ecx <- j
        mov     edx, DWORD PTR [rsp+8]      ; edx <- ix (ix = j - 1...)
        sub     edx, ecx                    ; j - 1 - j
        mov     ecx, edx                    ; ecx <- edx
        inc     ecx                         ; -1 + 1 .. 0 + 1 .. 1 + 1
        movsxd  rcx, ecx                    ; rcx <- ecx
        imul    rcx, rcx, 12                
        lea     rcx, QWORD PTR [rsp+32+rcx] ; addres of the kernel
        mov     edx, DWORD PTR [rsp]        ; edx <- i
        mov     r8d, DWORD PTR [rsp+12]     ; r8d <- iy
        sub     r8d, edx                    ; iy - i (iy = i - 1)
        mov     edx, r8d                    ; edx <- r8d
        inc     edx                         ; -1 + 1 .. 0 + 1 .. 1 + 1
        movsxd  rdx, edx                    ; rdx <- edx
        imul    eax, DWORD PTR [rcx+rdx*4]  ; 
        cvtsi2sd xmm0, eax                  ; cast the value to double
        movsd   xmm1, QWORD PTR [rsp+24]    ; xmm1 <- current sum
        addsd   xmm1, xmm0                  ; xmm1 + xmm0 = current sum + value added in this iteration             
        movsd   QWORD PTR [rsp+24], xmm1    ; sum <- xmm1
        jmp     Increment_ix
Set_pixel_value:
        cvttsd2si rax, QWORD PTR [rsp+24]   ; convert sum to an integer
        sar     rax, 4                      ; divide by 16 = kernelSum (1 + 2 + 1 + 2 + 4 + 2 + 1 + 2 + 1) 
        mov     ecx, DWORD PTR [rsp]        ; ecx <- i
        imul    ecx, DWORD PTR [rsp+112]    ; ecx <- i * width
        add     ecx, DWORD PTR [rsp+4]      ; ecx <- i * width + j
        movsxd  rcx, ecx                    ; rcx <- ecx
        mov     rdx, QWORD PTR [rsp+104]    ; rdx <- destination table address
        mov     BYTE PTR [rdx+rcx], al      ; lower bits 
        jmp     Increment_j
Finish:
        mov     rcx, QWORD PTR [rsp+72]     
        add     rsp, 88         
        ret 
BlurOneAsm ENDP                ; BlurTarget

END