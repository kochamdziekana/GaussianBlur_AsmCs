.data
source			dq 0		; pointer to the read array
destination		dq 0			; the height of the image
imageWidth		dd 0			; pointer for the modified array
imageHeight		dd 0			; the width of the image
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


zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi�gni�cia warto�ci odpowiedniej wysoko�ci przekazywanej w wywo�aniu metody jako argument
	mov r12d, r11d  ;i = offset, cmp i == height, i inc
	cmp r12d, r9d ; rejestr przechowuj�cy height
	je finisz
	inc r12d ; rejestr przechowuj�cy i
zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi�gni�cia warto�ci szeroko�ci
	;mov r13d ;j = 0, cmp j == width, j inc
	mov val, 00h
	mov wsum, 00h
	mov r13, val
	mov r14, wsum
;	mov eax, ; zmienna j jako drugi arg
;	cmp eax, ; rejestr przechowuj�cy _width
;	inc ; zmienna j
	jl wysokoscZaleznaPetla

wysokoscZaleznaPetla: ; zmienna iy okre�laj�ca indeks wysoko�ci do policzenia maski relatywnie do zmiennej i
;	mov ;iy = j - ZnacznyZakres, cmp iy == j + ZnacznyZakres + 1, iy inc

szerokoscZaleznaPetla: ; zmienna ix okre�laj�ca indeks szeroko�ci do policzenia maski relatywnie do zmiennej i
							;mov ;ix = j - ZnacznyZakres, cmp ix == j + rs + 1, ix inc
;ld r13d							;int x = min(width - 1, max(0, ix)); -> width - 1 cmp, 0 cmp ix -> width-1 cmp 0 || width-1 cmp ix
							;int y = min(height - 1, max(0, iy)); -> height - 1 cmp, 0 cmp iy -> height-1 cmp 0 || height-1 cmp iy
							;int dsq = (ix - j) * (ix - j) + (iy - i) * (iy - i); ->  ix - 



policzEksponente: ; zast�puje metod� Math.Exp


finisz:
	pop	rsi
	pop	rdi
	pop	rbp

	ret
BlurOneAsm ENDP	

end