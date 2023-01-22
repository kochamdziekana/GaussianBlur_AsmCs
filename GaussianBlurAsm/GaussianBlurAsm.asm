.data
source			dq 0		; pointer to the read array
destination		dq 0			; the height of the image
imageWidth		dd 0			; pointer for the modified array
imageHeight		dd 0			; the width of the image
val				dq 0.0
wsum			dq 0.0

.code
;BlurOneAsm PROC source: DWORD, destination: DWORD, _width: DWORD, _height: DWORD, offset: DWORD, kernel: DWORD, kernelSum: DWORD, kernelSize: DWORD
BlurOneAsm PROC 
;	mov	 r10d,			DWORD ptr[rbp + 48]; radial
;	mov	 r11d,			DWORD ptr[rbp + 56]; tableOffset
;	push rbp
;	push rdi
;	push rsi
;	mov source,			rcx ; rcx = source
;	mov destination,	rdx ; rdx = destination
;	mov imageWidth,		r8d ; r8d = width
;	mov imageHeight,	r9d ; r9d = height
;
;
;zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi¹gniêcia wartoœci odpowiedniej wysokoœci przekazywanej w wywo³aniu metody jako argument
;	mov r12d, r11d  ;i = offset, cmp i == height, i inc
;	cmp r12d, r9d ; rejestr przechowuj¹cy height
;	je finisz
;	inc r12d ; rejestr przechowuj¹cy i
;zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi¹gniêcia wartoœci szerokoœci
;	;mov r13d ;j = 0, cmp j == width, j inc
;	mov val, 00h
;	mov wsum, 00h
;	mov r13, val
;	mov r14, wsum
;;	mov eax, ; zmienna j jako drugi arg
;;	cmp eax, ; rejestr przechowuj¹cy _width
;;	inc ; zmienna j
;	jl wysokoscZaleznaPetla
;
;wysokoscZaleznaPetla: ; zmienna iy okreœlaj¹ca indeks wysokoœci do policzenia maski relatywnie do zmiennej i
;;	mov ;iy = j - ZnacznyZakres, cmp iy == j + ZnacznyZakres + 1, iy inc
;
;szerokoscZaleznaPetla: ; zmienna ix okreœlaj¹ca indeks szerokoœci do policzenia maski relatywnie do zmiennej i
;							;mov ;ix = j - ZnacznyZakres, cmp ix == j + rs + 1, ix inc
;;ld r13d							;int x = min(width - 1, max(0, ix)); -> width - 1 cmp, 0 cmp ix -> width-1 cmp 0 || width-1 cmp ix
;							;int y = min(height - 1, max(0, iy)); -> height - 1 cmp, 0 cmp iy -> height-1 cmp 0 || height-1 cmp iy
;							;int dsq = (ix - j) * (ix - j) + (iy - i) * (iy - i); ->  ix - 
;
;
;
;policzEksponente: ; zastêpuje metodê Math.Exp
;
;
;finisz:
;	pop	rsi
;	pop	rdi
;	pop	rbp
;
;	ret
;	push rbp
;	push rdi
;	push rsi
;	mov source,			rcx ; rcx = source
;	mov destination,	rdx ; rdx = destination
;	mov imageWidth,		r8d ; r8d = width
;	mov imageHeight,	r9d ; r9d = height
			
						fild        dword ptr [rcx+rax]  
			add         al,ch  
			stos        dword ptr [rdi]  
			idiv        eax,edi  
			dec         dword ptr [rbx+52085h]  
        ;for (int j = offset; j < height; ++j) {
			add         byte ptr [rcx+8EB0445h],cl  
			mov         eax,dword ptr [rbp+4]  
			inc         eax  
			mov         dword ptr [rbp+4],eax  
			mov         eax,dword ptr [height]  
			cmp         dword ptr [rbp+4],eax  
			jae         BlurTargetTwoIntrinsics+297h (07FFDBC581D87h)  
        ;for (int i = 0; i < width - kernelSize; ++i) {
			mov         dword ptr [rbp+24h],0  
			jmp         BlurTargetTwoIntrinsics+72h (07FFDBC581B62h)  
			mov         eax,dword ptr [rbp+24h]  
			inc         eax  
			mov         dword ptr [rbp+24h],eax  
			mov         eax,dword ptr [kernelSize]  
			mov         ecx,dword ptr [width]  
			sub         ecx,eax  
			mov         eax,ecx  
			cmp         dword ptr [rbp+24h],eax  
			jae         BlurTargetTwoIntrinsics+292h (07FFDBC581D82h)  
        ;float buffer = 0;
			xorps       xmm0,xmm0  
			movss       dword ptr [rbp+44h],xmm0  
        ;for (int y = 0; y < kernelSize; y++) {
			mov         dword ptr [rbp+64h],0  
			jmp         BlurTargetTwoIntrinsics+0A4h (07FFDBC581B94h)  
			mov         eax,dword ptr [rbp+64h]  
			inc         eax  
			mov         dword ptr [rbp+64h],eax  
			mov         eax,dword ptr [kernelSize]  
			cmp         dword ptr [rbp+64h],eax  
			jae         BlurTargetTwoIntrinsics+263h (07FFDBC581D53h)  
        ;for (int x = 0; x < kernelSize; x += 4) {
			mov         dword ptr [rbp+84h],0  
			jmp         BlurTargetTwoIntrinsics+0CEh (07FFDBC581BBEh)  
			mov         eax,dword ptr [rbp+84h]  
			add         eax,4  
			mov         dword ptr [rbp+84h],eax  
			mov         eax,dword ptr [kernelSize]  
			cmp         dword ptr [rbp+84h],eax  
			jae         BlurTargetTwoIntrinsics+25Eh (07FFDBC581D4Eh)  

        ;UINT32 pixels = *(UINT32*)(image + (j + y) * width + i + x); // x x x x 
			mov         eax,dword ptr [rbp+64h]  
			mov         ecx,dword ptr [rbp+4]  
			add         ecx,eax  
			mov         eax,ecx  
			imul        eax,dword ptr [width]  
			mov         eax,eax  
			mov         rcx,qword ptr [image]  
			add         rcx,rax  
			mov         rax,rcx  
			movsxd      rcx,dword ptr [rbp+24h]  
			add         rax,rcx  
			movsxd      rcx,dword ptr [rbp+84h]  
			mov         eax,dword ptr [rax+rcx]  
			mov         dword ptr [rbp+0A4h],eax  
        ;__m128i convertedPixels = _mm_set1_epi32(0);
			movdqa      xmm0,xmmword ptr [__xmm@00000000000000000000000000000000 (07FFDBC58A910h)]  
			movdqa      xmmword ptr [rbp+370h],xmm0  
			movdqa      xmm0,xmmword ptr [rbp+370h]  
			movdqa      xmmword ptr [rbp+0D0h],xmm0  
        ;convertedPixels = _mm_insert_epi32(convertedPixels, pixels, 0);
			movdqa      xmm0,xmmword ptr [rbp+0D0h]  
			pinsrd      xmm0,dword ptr [rbp+0A4h],0  
			movdqa      xmmword ptr [rbp+3A0h],xmm0  
			movdqa      xmm0,xmmword ptr [rbp+3A0h]  
			movdqa      xmmword ptr [rbp+0D0h],xmm0  
        ;__m128i pixelVector = _mm_cvtepu8_epi32(convertedPixels);
			movdqa      xmm0,xmmword ptr [rbp+0D0h]  
			pmovzxbd    xmm0,xmm0  
			movdqa      xmmword ptr [rbp+3D0h],xmm0  
			movdqa      xmm0,xmmword ptr [rbp+3D0h]  
			movdqa      xmmword ptr [rbp+100h],xmm0  
        ;__m128 convertedIntegers = _mm_cvtepi32_ps(pixelVector);
			cvtdq2ps    xmm0,xmmword ptr [rbp+100h]  
			movaps      xmmword ptr [rbp+400h],xmm0  
			movaps      xmm0,xmmword ptr [rbp+400h]  
			movaps      xmmword ptr [rbp+130h],xmm0  
        ;__m128 kernelRow = _mm_load_ps(kernel + y * kernelSize + x);
			mov         eax,dword ptr [rbp+64h]  
			imul        eax,dword ptr [kernelSize]  
			mov         eax,eax  
			mov         rcx,qword ptr [kernel]  
			lea         rax,[rcx+rax*4]  
			movsxd      rcx,dword ptr [rbp+84h]  
			lea         rax,[rax+rcx*4]  
			movups      xmm0,xmmword ptr [rax]  
			movaps      xmmword ptr [rbp+430h],xmm0  
			movaps      xmm0,xmmword ptr [rbp+430h]  
			movaps      xmmword ptr [rbp+160h],xmm0  
        ;__m128 result = _mm_mul_ps(convertedIntegers, kernelRow);
			movaps      xmm0,xmmword ptr [rbp+130h]  
			mulps       xmm0,xmmword ptr [rbp+160h]  
			movaps      xmmword ptr [rbp+460h],xmm0  
			movaps      xmm0,xmmword ptr [rbp+460h]  
			movaps      xmmword ptr [rbp+190h],xmm0  

        ;__m128 sum = _mm_hadd_ps(result, result);
			movaps      xmm0,xmmword ptr [rbp+190h]  
			haddps      xmm0,xmmword ptr [rbp+190h]  
			movaps      xmmword ptr [rbp+490h],xmm0  
			movaps      xmm0,xmmword ptr [rbp+490h]  
			movaps      xmmword ptr [rbp+1C0h],xmm0  
        ;sum = _mm_hadd_ps(sum, sum);
			movaps      xmm0,xmmword ptr [rbp+1C0h]  
			haddps      xmm0,xmmword ptr [rbp+1C0h]  
			movaps      xmmword ptr [rbp+4C0h],xmm0  
			movaps      xmm0,xmmword ptr [rbp+4C0h]  
			movaps      xmmword ptr [rbp+1C0h],xmm0  

        ;//buffer += _mm_cvtss_f32(_mm_shuffle_ps(sum, sum, _MM_SHUFFLE(0, 0, 0, 2)));
        ;buffer += *(float*)(&sum);
			movss       xmm0,dword ptr [rbp+44h]  
			addss       xmm0,dword ptr [rbp+1C0h]  
			movss       dword ptr [rbp+44h],xmm0  
        ;           }
			jmp         BlurTargetTwoIntrinsics+0BFh (07FFDBC581BAFh)  
        ;        }
			jmp         BlurTargetTwoIntrinsics+9Ch (07FFDBC581B8Ch)  
		;output[j * width + i] = buffer / kernelSum; // buffer/kernelSum
			movss       xmm0,dword ptr [rbp+44h]  
			divss       xmm0,dword ptr [kernelSum]  
			cvttss2si   eax,xmm0  
			mov         ecx,dword ptr [rbp+4]  
			imul        ecx,dword ptr [width]  
			add         ecx,dword ptr [rbp+24h]  
			mov         ecx,ecx  
			mov         rdx,qword ptr [output]  
			mov         byte ptr [rdx+rcx],al  
        ;    }
			jmp         BlurTargetTwoIntrinsics+6Ah (07FFDBC581B5Ah)  
        ;}
			jmp         BlurTargetTwoIntrinsics+4Ah (07FFDBC581B3Ah)  
    }
			mov         rcx,qword ptr [rbp+4D8h]  
			xor         rcx,rbp  
			call        __security_check_cookie (07FFDBC581168h)  
			lea         rsp,[rbp+4E8h]  
			pop         rdi  
			pop         rbp  
			ret  

BlurOneAsm ENDP	

end