.data
source			dq 0		; pointer to the read array
destination		dq 0			; the height of the image
imageWidth		dd 0			; pointer for the modified array
imageHeight		dd 0			; the width of the image
WartoscPI		EQU 3.14159265358979
WartoscE		EQU 2.71828182845904
radSq			dq 2.0
rs				dq 2.57
val				dq 0.0
wsum			dq 0.0

.code
;BlurOneAsm PROC source: DWORD, destination: DWORD, _width: DWORD, _height: DWORD, radial: DWORD, tableOffset: DWORD
BlurOneAsm PROC 
	mov	 r10d,			DWORD ptr[rbp + 48]; radial
	mov	 r11d,			DWORD ptr[rbp + 56]; tableOffset
	push rbp
	push rdi
	push rsi
	mov source,			rcx ; rcx = source
	mov destination,	rdx ; rdx = destination
	mov imageWidth,		r8d ; r8d = width
	mov imageHeight,	r9d ; r9d = height

	vxorps		xmm1,xmm1,xmm1
	vcvtsi2sd	xmm1,xmm1,r10d
	vmovd		xmm2,qword ptr[radSq]
	vmulsd		xmm1,xmm1,xmm2
	vmulsd		xmm1,xmm1,xmm2
	vcvtsd2si	r12d,xmm1
	push		r12
	mov			r12d, DWORD ptr[rbp]
	
	;vxorps      xmm1,xmm1,xmm1  
	vxorps      xmm0,xmm0,xmm0  
	vcvtsi2sd   xmm0,xmm0,r10d ; change radial int into a double
	vmulsd		xmm0,xmm0,qword ptr [rs] ; multiply radius with rs 
	vcvttsd2si	r14d,xmm0; change double into an int

zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi¹gniêcia wartoœci odpowiedniej wysokoœci przekazywanej w wywo³aniu metody jako argument
	mov r12d, r11d  ;i = offset, cmp i == height, i inc
	cmp r12d, r9d ; rejestr przechowuj¹cy height
	je finisz
	inc r12d ; rejestr przechowuj¹cy i
zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi¹gniêcia wartoœci szerokoœci
	;mov r13d ;j = 0, cmp j == width, j inc
	mov val, 00h
	mov wsum, 00h
	mov r13, val
	mov r14, wsum
;	mov eax, ; zmienna j jako drugi arg
;	cmp eax, ; rejestr przechowuj¹cy _width
;	inc ; zmienna j
	jl wysokoscZaleznaPetla

wysokoscZaleznaPetla: ; zmienna iy okreœlaj¹ca indeks wysokoœci do policzenia maski relatywnie do zmiennej i
;	mov ;iy = j - ZnacznyZakres, cmp iy == j + ZnacznyZakres + 1, iy inc

szerokoscZaleznaPetla: ; zmienna ix okreœlaj¹ca indeks szerokoœci do policzenia maski relatywnie do zmiennej i
							;mov ;ix = j - ZnacznyZakres, cmp ix == j + rs + 1, ix inc
;ld r13d							;int x = min(width - 1, max(0, ix)); -> width - 1 cmp, 0 cmp ix -> width-1 cmp 0 || width-1 cmp ix
							;int y = min(height - 1, max(0, iy)); -> height - 1 cmp, 0 cmp iy -> height-1 cmp 0 || height-1 cmp iy
							;int dsq = (ix - j) * (ix - j) + (iy - i) * (iy - i); ->  ix - 



policzEksponente: ; zastêpuje metodê Math.Exp


finisz:
	pop	rsi
	pop	rdi
	pop	rbp

	ret
BlurOneAsm ENDP	

end