.code
WartoscPI = 3.14159265358979
WartoscE = 2.71828182845904;
BlurOneAsm PROC

  mov DWORD PTR [rsp+32], r9d ; Przypisanie ze stosu 4 przekazanej zmiennej do rejestru 32 bitowego rejestru r9d
  mov DWORD PTR [rsp+24], r8 ; Przypisanie ze stosu 3 przekazanej zmiennej do rejestru r8 
  mov DWORD PTR [rsp+16], edx ; Przypisanie ze stosu 2 zmiennej przekazanej do rejestru edx
  mov DWORD PTR [rsp+8], ecx ; Przypisanie ze stosu  zmiennej przekazanej do rejestru ecx

zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi�gni�cia warto�ci odpowiedniej wysoko�ci przekazywanej w wywo�aniu metody jako argument
	
zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi�gni�cia warto�ci szeroko�ci

wysokoscZaleznaPetla: ; zmienna iy okre�laj�ca indeks wysoko�ci do policzenia maski relatywnie do zmiennej i

szerokoscZaleznaPetla: ; zmienna ix okre�laj�ca indeks szeroko�ci do policzenia maski relatywnie do zmiennej i


policzEksponente: ; zast�puje metod� Math.Exp

znajdzMax: ; zast�puje metod� Math.Max

znajdzMin: ; zast�puje metod� Math.Min

znajdzNajblizszyWiekszyInteger: ; zast�puje metod� Math.Ceiling

zaokraglijDoIntegera: ; zast�puje metod� Math.Round