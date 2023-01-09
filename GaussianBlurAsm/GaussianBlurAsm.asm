.code
WartoscPI = 3.14159265358979
WartoscE = 2.71828182845904;
BlurOneAsm PROC

  mov DWORD PTR [rsp+32], r9d ; Przypisanie ze stosu 4 przekazanej zmiennej do rejestru 32 bitowego rejestru r9d
  mov DWORD PTR [rsp+24], r8 ; Przypisanie ze stosu 3 przekazanej zmiennej do rejestru r8 
  mov DWORD PTR [rsp+16], edx ; Przypisanie ze stosu 2 zmiennej przekazanej do rejestru edx
  mov DWORD PTR [rsp+8], ecx ; Przypisanie ze stosu  zmiennej przekazanej do rejestru ecx

zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi¹gniêcia wartoœci odpowiedniej wysokoœci przekazywanej w wywo³aniu metody jako argument
	
zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi¹gniêcia wartoœci szerokoœci

wysokoscZaleznaPetla: ; zmienna iy okreœlaj¹ca indeks wysokoœci do policzenia maski relatywnie do zmiennej i

szerokoscZaleznaPetla: ; zmienna ix okreœlaj¹ca indeks szerokoœci do policzenia maski relatywnie do zmiennej i


policzEksponente: ; zastêpuje metodê Math.Exp

znajdzMax: ; zastêpuje metodê Math.Max

znajdzMin: ; zastêpuje metodê Math.Min

znajdzNajblizszyWiekszyInteger: ; zastêpuje metodê Math.Ceiling

zaokraglijDoIntegera: ; zastêpuje metodê Math.Round
