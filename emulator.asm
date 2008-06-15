; autor: Marian Marek Kedzierski, mk248269
SYS_EXIT          equ   1
SYS_READ          equ   3
SYS_WRITE         equ   4
SYS_OPEN          equ   5
SYS_CLOSE         equ   6
STDOUT            equ   1
STDERR            equ   2

MAX_PROGRAM_LEN   equ   32764
PAMIEC_LEN        equ   65536
HEAP_SIZE         equ   32768  ; rozmiar sterty


section .data
  newline                   db 10, 0 ; !!!

  ; komunikaty o bledach
  err_prog_too_large        db    "ERROR: program too large, exiting", 10, 0
  err_prog_too_large_len    equ   $ - err_prog_too_large
  
  err_inv_opcode            db    "ERROR: invalid opcode, exiting", 10, 0
  err_inv_opcode_len        equ   $ - err_inv_opcode
  

section .bss

  pamiec resd PAMIEC_LEN ; bloki: program; sterta; stos
  fd resd 1
  stack_begin resd 1 ; najmniejszy adres, jaki moze przyjac wierzcholek stosu (pelnego)
  stack_end resd 1   ; najwiekszy adres, jaki moze przyjac wierzcholek stosu (pustego)
  program_len resd 1
  REG_BP resd 1 ; rejestr base pointer
  wykonane_instr resd 1


section .text

  extern printf
  extern get_file_size
  
  global main
  
  main:
    ; odczytanie argumentu
    mov esi, [esp + 2*4]
    mov esi, [esi + 4]
    
    ; teraz esi ma wskaznik na nazwe programu - odczytajmy go
    mov eax, SYS_OPEN
    mov ebx, esi
    xor ecx, ecx
    int 80h
  
    ; odczytajmy deskryptor pliku
    mov [fd], eax
    
    ; inicjalizacje
    call init
  
    ; zamkniecie pliku z programem
    mov eax, SYS_CLOSE
    mov ebx, [fd]
    int 80h
    
    ; wykonaj emulacje kodu
    call emuluj
    
    ; wywolanie konca
    xor eax, eax
    call exit
  ; end main
  
  
  ; inicjalizacje pamieci operacyjnej i zmiennych pomocniczych
  init:
    ; odczytajmy program
    mov eax, SYS_READ
    mov ebx, [fd]
    mov ecx, pamiec
    mov edx, PAMIEC_LEN
    int 80h
  
    ; oblicz dlugosc programu
    push DWORD [fd]
    call get_file_size
    pop ebx
    mov [program_len], eax
    
    ; !!!
    call wypisz_eax
    mov eax, newline
    call message_eax
    
    ; znajdz poczatek i koniec stosu
    mov eax, [program_len]
    add eax, HEAP_SIZE
    sub eax, 4
    mov [stack_begin], eax
    
    mov eax, PAMIEC_LEN
    sub eax, 4
    mov [stack_end], eax
    
    ; sprawdz, czy program nie jest za dlugi
    cmp DWORD [program_len], MAX_PROGRAM_LEN
    jbe init_dalej
    
    mov eax, err_prog_too_large
    mov ebx, err_prog_too_large_len
    call error
    
    init_dalej:
  
    ; pozostale inicjalizacje
    mov esi, 0 ; IP := 0
    lea edi, [PAMIEC_LEN - 4] ; inicjalizacja SP
    mov DWORD [REG_BP], 0 ; BP := 0
    mov DWORD [wykonane_instr], 0 ; licznik wykonanych instrukcji na zero
    
  ret
  
  
  ; wykonanie emulacji kodu
  emuluj:
    petla_glowna:
      ; !!!
      mov eax, newline
      call message_eax
      
      xor eax, eax
      mov al, [pamiec + esi]
      
      push eax
      mov eax, esi
      call wypisz_eax ; !!!
      pop eax
      
      ; obecnie polecenie jest przyrownywane kolejno do poszczegolnych mozliwosci
      ; mozna byloby jednak zrobic w tym miejscu wyszukiwanie binarne,
      ; ktore powinno przyspieszyc dzialanie emulatora
      
      cmp eax, 0
        jne emuluj_dalej0
        call INSTR_SYS
        jmp nastepny_krok
      emuluj_dalej0:
  
      cmp eax, 1
        jne emuluj_dalej1
        call INSTR_PUSH
        jmp nastepny_krok
      emuluj_dalej1:
  
      cmp eax, 2
        jne emuluj_dalej2
        call INSTR_PUSH_BP
        jmp nastepny_krok
      emuluj_dalej2:
  
      cmp eax, 3
        jne emuluj_dalej3
        call INSTR_PUSH_SP
        jmp nastepny_krok
      emuluj_dalej3:
  
      cmp eax, 4
        jne emuluj_dalej4
        call INSTR_STORE
        jmp nastepny_krok
      emuluj_dalej4:
  
      cmp eax, 5
        jne emuluj_dalej5
        call INSTR_LOAD
        jmp nastepny_krok
      emuluj_dalej5:
  
      cmp eax, 6
        jne emuluj_dalej6
        call INSTR_JMP
        jmp nastepny_krok
      emuluj_dalej6:
  
      cmp eax, 7
        jne emuluj_dalej7
        call INSTR_CALL
        jmp nastepny_krok
      emuluj_dalej7:
  
      cmp eax, 8
        jne emuluj_dalej8
        call INSTR_RET
        jmp nastepny_krok
      emuluj_dalej8:
  
      cmp eax, 9
        jne emuluj_dalej9
        call INSTR_RETF
        jmp nastepny_krok
      emuluj_dalej9:
  
      cmp eax, 10
        jne emuluj_dalej10
        call INSTR_ADD
        jmp nastepny_krok
      emuluj_dalej10:
  
      cmp eax, 11
        jne emuluj_dalej11
        call INSTR_SUB
        jmp nastepny_krok
      emuluj_dalej11:
  
      cmp eax, 12
        jne emuluj_dalej12
        call INSTR_MUL
        jmp nastepny_krok
      emuluj_dalej12:
  
      cmp eax, 13
        jne emuluj_dalej13
        call INSTR_DIV
        jmp nastepny_krok
      emuluj_dalej13:
  
      cmp eax, 14
        jne emuluj_dalej14
        call INSTR_AND
        jmp nastepny_krok
      emuluj_dalej14:
  
      cmp eax, 15
        jne emuluj_dalej15
        call INSTR_OR
        jmp nastepny_krok
      emuluj_dalej15:
  
      cmp eax, 16
        jne emuluj_dalej16
        call INSTR_NOT
        jmp nastepny_krok
      emuluj_dalej16:
  
      cmp eax, 17
        jne emuluj_dalej17
        call INSTR_EQ
        jmp nastepny_krok
      emuluj_dalej17:
  
      cmp eax, 18
        jne emuluj_dalej18
        call INSTR_AB
        jmp nastepny_krok
      emuluj_dalej18:
  
      cmp eax, 19
        jne emuluj_dalej19
        call INSTR_AE
        jmp nastepny_krok
      emuluj_dalej19:
  
      cmp eax, 20
        jne emuluj_dalej20
        call INSTR_JC
        jmp nastepny_krok
      emuluj_dalej20:
      
      ; nieprawidlowa instrukcja
      mov eax, err_inv_opcode
      mov ebx, err_inv_opcode_len
      call error
  
  
      nastepny_krok:
      
      call wypisz_stos
      
      ; zliczamy wykonana instrukcje
      inc DWORD [wykonane_instr]
      
      ; jesli wyskoczylismy z IP poza tekst programu to konczymy wykonanie
      mov eax, [program_len]
      cmp esi, eax
      jae koniec_petli_glownej
      
      jmp petla_glowna
  
    koniec_petli_glownej:
  
  ret
  