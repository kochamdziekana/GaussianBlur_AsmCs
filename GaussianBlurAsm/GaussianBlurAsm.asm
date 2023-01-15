.code
WartoscPI		EQU 3.14159265358979
WartoscE		EQU 2.71828182845904
rs				dd 2.57
val				dd 0.0
wsum			dd 0.0

;BlurOneAsm PROC source: DWORD, destination: DWORD, _width: DWORD, _height: DWORD, radial: DWORD, tableOffset: DWORD
BlurOneAsm PROC 
	push		rbp
	push		rdi
	push		rsi
	mov			rbp, rsp
	mov			DWORD ptr[rsp +	32],r9d  ; source, ptr on source table
	mov			DWORD ptr[rsp +	24],r8d ; destination, ptr on destination table
	mov			DWORD ptr[rsp +	16],edx ; _width of the tables
	mov			DWORD ptr[rsp +	8 ],ecx ; height of the tables
	mov			QWORD ptr[rsp	  ],r10 ; height of the tables
	mov			QWORD ptr[rsp -	8 ],r11 ; height of the tables
	vxorps      xmm0,xmm0,xmm0  
	vcvtsi2sd   xmm0,xmm0, r9d ; change int into a double
	vmulsd		xmm0,xmm0, qword ptr [rs] ; multiply radius with rs 
	vcvttsd2si	r14d,xmm0; change double into an int
zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi¹gniêcia wartoœci odpowiedniej wysokoœci przekazywanej w wywo³aniu metody jako argument
;	push ecx
	mov ecx, r13d ;i = offset, cmp i == height, i inc
	cmp ecx, r11d ; rejestr przechowuj¹cy height
	;inc ecx ; rejestr przechowuj¹cy i
	jmp finisz ; do zmiany na je
	jl zakresSzerokosciPetla ; jesli nie jest koniec to idzie do pêtli z szerokoœci¹
;	pop ecx
zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi¹gniêcia wartoœci szerokoœci
;	mov ;j = 0, cmp j == width, j inc
	mov val, 00h
	mov wsum, 00h
;	mov eax, ; zmienna j jako drugi arg
;	cmp eax, ; rejestr przechowuj¹cy _width
;	inc ; zmienna j
	jl wysokoscZaleznaPetla
wysokoscZaleznaPetla: ; zmienna iy okreœlaj¹ca indeks wysokoœci do policzenia maski relatywnie do zmiennej i
;	mov ;iy = j - ZnacznyZakres, cmp iy == j + ZnacznyZakres + 1, iy inc

szerokoscZaleznaPetla: ; zmienna ix okreœlaj¹ca indeks szerokoœci do policzenia maski relatywnie do zmiennej i
;	mov ;ix = j - ZnacznyZakres, cmp ix == j + rs + 1, ix inc


policzEksponente: ; zastêpuje metodê Math.Exp

znajdzMinimum:


finisz:
	pop	rsi
	pop	rdi
	pop	rbp

BlurOneAsm ENDP	

end