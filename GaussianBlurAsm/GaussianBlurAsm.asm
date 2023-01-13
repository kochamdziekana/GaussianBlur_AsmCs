.code
WartoscPI	dd 3.14159265358979
WartoscE	dd 2.71828182845904

BlurOneAsm PROC source: DWORD, destination: DWORD, _width: DWORD, _height: DWORD, radial: DWORD, tableOffset: DWORD
push        rbp
push        rdi
push        rsi
mov rdx, QWORD ptr[rsi]

ret 0


zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi¹gniêcia wartoœci odpowiedniej wysokoœci przekazywanej w wywo³aniu metody jako argument
	
zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi¹gniêcia wartoœci szerokoœci

wysokoscZaleznaPetla: ; zmienna iy okreœlaj¹ca indeks wysokoœci do policzenia maski relatywnie do zmiennej i

szerokoscZaleznaPetla: ; zmienna ix okreœlaj¹ca indeks szerokoœci do policzenia maski relatywnie do zmiennej i


policzEksponente: ; zastêpuje metodê Math.Exp

BlurOneAsm ENDP	

end