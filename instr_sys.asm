; autor: Marian Marek Kedzierski, mk248269
; **************************** INSTR_SYS.ASM ********************************
; przerwania systemowe

section .data

  sys_mesg                    db    "SYS ", 0
  ile_instr_mesg              db    "Program zakonczony poprawnie (liczba wykonanych instrukcji: %d)", 10, 0
  MAX_WRITTEN_LEN             equ   65532
  
  ; komunikaty o bledach
  err_unhandled_int           db    "ERROR: unhandled interrupt, exiting", 10, 0
  err_unhandled_int_len       equ   $ - err_unhandled_int

  err_io                      db    "ERROR: illegal I/O operation, exiting", 10, 0
  err_io_len                  equ   $ - err_io
  
  
section .text
  
  ;; TESTED
  ; wywolanie przerwania systemowego
  INSTR_SYS:
    mov eax, sys_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; POP A
    call pop_stack
    ; teraz w eax jest numer przerwania
    
    call wypisz_eax ; !!!
    
    ; system(A)
    cmp eax, 0
      jne INSTR_SYS_dalej1
      ; wypisanie liczby wykonanych instrukcji
      push DWORD [wykonane_instr]
      push ile_instr_mesg
      call printf
      pop eax
      pop eax
      call flush_stdout
      
      ; wywolanie konca
      xor eax, eax ; kod wyjscia: 0
      call exit
    
    INSTR_SYS_dalej1:
    cmp eax, 1
      jne INSTR_SYS_dalej2
      ; wywolanie WRITE
      call pop_stack
      
      push esi
      push edi
        lea ecx, [pamiec + eax]
        mov edx, [ecx]
        cmp edx, MAX_WRITTEN_LEN
          jbe INSTR_SYS_ok
          mov eax, err_io
          mov ebx, err_io_len
          call error
        
        INSTR_SYS_ok:
        add ecx, 4
        mov eax, SYS_WRITE
        mov ebx, STDERR ; !!! STDOUT
        int 80h
      pop edi
      pop esi
      jmp INSTR_SYS_koniec
    
    INSTR_SYS_dalej2:
      ; nieobslugiwane przerwanie
      mov eax, err_unhandled_int
      mov ebx, err_unhandled_int_len
      call error
    
    INSTR_SYS_koniec:
  ret 
