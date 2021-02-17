# Verilog-project
An implementation of a decoder using 3 algorithms, registers that hold the input signals, a demus and a mux for selecting and enableing the output of a coded message

Decryption_regfile:
     Aici mi se pare ca am uitat sa scriu comentarii, dar codul funtioneaza in modul urmator:
     Ma asigur ca semnalele de read si write nu sunt valide in acelasi timp. Daca semnalul write este valid,
    in functie de adresa aleg registrul in care imi salvez datele (doar ultimii 2 biti pentru select) si ridic semnalul
    done.
     Daca semnalul read este valid, copiez valoarea registrului ales iar in functie de adresa, o pun in rdata
    si ridic semnalul de done.
     Acum ca ma gandesc puteam sa fac asta o singura data, nu in fiecare caz. In cazul in care primesc o
    adresa gresita, ridicam semnalele done si error ca sa semnalam acest lucru.
    
    
 Caesar:
     Doar astept sa primesc ceva pe intrare si scriu pe iesire valoarea din care scad cheia primita la ciclul
    urmator
     Cand nu mai primesc nimic pe intrare, valid_o devine 0.


Scytale:
     Aici am pus ceva mai multe comentarii deci o sa fac un rezumat
     Cand am citit datele de intrare am cautat pozitia in matrice(care e de fapt vector) astfel incat cand
    citesc elementele in ordine sa am propozitia decriptata
     Am constatat ca daca ma duc mereu la pozitia de dedesubt si scad ultima pozitie cand ies din
    matrice(numarul de elem - 1) ma duce pe coloana urmatoare la linia 0, deci urmatorul element.
 
 
Zigzag:
     Si aici am pus ceva comentarii, dar e greu de citit codul. Am counter1>>2 si counter1 -
    (counter1>>2)*4 care sunt catul Q si restul R impartirii la 4
     Am Q elemente pe prima si a treia linie si 2Q pe a doua la care adaug in functie de rest un element in
    plus. Gasesc pozitia in vector al carui elem e primul de pe linia lui si doar incrementez acea pozitie cand
    trebui sa-l scriu. Am o referinta pentru fiecare linie care reprezinta pozitia valorii anterioare de care tin
    cont cand scriu pe iesire. Daca am trecut devreuna, stiu pe care sa o scriu la urmatorul ciclu.
     la cheia 2 in schimb adun elementele de pe prima linipentru a ajunge la primul element de pe a doua
    linie si scad acel nr-1 pentru a ma intoarce. 
 
 
 Demux:
     E o metoda stupida, but if it works, it works.
     Cand gasesc valid pe intrare astept 3 cicluri de ceas in al 4-lea si ultimul de fapt in care am valid_i
    incep sa scriu elemente pe iesire, ca in ceasul 5 sa am deja prima valoare dorita si continui inca 3 ciclii de
    ceas
     Cand am terminat de scris cele 4 valori sunt in ciclul 3 de scriere si i = 2, intru in ciclul 4 de scriere si
    pot da valorile urmatoare pe output, ca ciclul de dupa sa am valorile cerute

 
 Mux:
    Pun datele de intrare pe iesire in functie de select
