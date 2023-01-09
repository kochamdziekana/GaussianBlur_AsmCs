.code
WartoscPI = 3.14159265358979
WartoscE = 2.71828182845904;
BlurOneAsm PROC

zakresWysokosciPetla: ; zmienna i jest tu inkrementowana do osi¹gniêcia wartoœci odpowiedniej wysokoœci przekazywanej w wywo³aniu metody jako argument
	
zakresSzerokosciPetla: ; zmienna j jest inkrementowana do osi¹gniêcia wartoœci szerokoœci

wysokoscZaleznaPetla: ; zmienna iy okreœlaj¹ca indeks wysokoœci do policzenia maski relatywnie do zmiennej i

szerokoscZaleznaPetla: ; zmienna ix okreœlaj¹ca indeks szerokoœci do policzenia maski relatywnie do zmiennej i


policzEksponente: ; zastêpuje metodê Math.Exp

znajdzMax: ; zastêpuje metodê Math.Max

znajdzMin: ; zastêpuje metodê Math.Min

znajdzNajblizszyWiekszyInteger: ; zastêpuje metodê Math.Ceiling

zaokraglijDoIntegera: ; zastêpuje metodê Math.Round
