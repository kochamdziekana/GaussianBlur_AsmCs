.code
WartoscPI	dd 3.14159265358979
WartoscE	dd 2.71828182845904

BlurOneAsm PROC source: DWORD, destination: DWORD, _width: DWORD, _height: DWORD, radial: DWORD, tableOffset: DWORD
push        rbp
push        rdi
push        rsi
mov rdx, QWORD ptr[rsi]

ret 0


zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi�gni�cia warto�ci odpowiedniej wysoko�ci przekazywanej w wywo�aniu metody jako argument
	
zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi�gni�cia warto�ci szeroko�ci

wysokoscZaleznaPetla: ; zmienna iy okre�laj�ca indeks wysoko�ci do policzenia maski relatywnie do zmiennej i

szerokoscZaleznaPetla: ; zmienna ix okre�laj�ca indeks szeroko�ci do policzenia maski relatywnie do zmiennej i


policzEksponente: ; zast�puje metod� Math.Exp

BlurOneAsm ENDP	

end