; autor: Marian Marek Kedzierski, mk248269
; **************************** POMOCNICZE.ASM ********************************

section .data
  ; komunikaty o bledach
  err_st_overflow           db    "ERROR: stack overflow, exiting", 10, 0
  err_st_overflow_len       equ   $ - err_st_overflow

  err_st_underflow          db    "ERROR: stack underflow, exiting", 10, 0
  err_st_underflow_len      equ   $ - err_st_underflow
  
  liczba                    db    "%u ", 0

section .bss

  wypisz_eax_buf resb 20
  
section .text

  extern flush_stdout
  
  ; !!!
  reszta_inita:
    ; pozostale inicjalizacje
    mov esi, 0 ; IP := 0
    lea edi, [PAMIEC_LEN - 4] ; inicjalizacja SP
    mov DWORD [REG_BP], 0 ; BP := 0
    mov DWORD [wykonane_instr], 0 ; licznik wykonanych instrukcji na zero
  ret
  
  ; na eax jest liczba do wrzucenia na wirtualny stos
  push_stack:
    ; czy nie bedzie przepelnienia?
    cmp edi, [stack_begin]
      ja push_stack_ok
      mov eax, err_st_overflow
      mov ebx, err_st_overflow_len
      call error
  
    push_stack_ok:
    
    mov [pamiec + edi], eax
    sub edi, 4
  ret


  ; na eax polozymy liczbe z wierzcholka stosu
  pop_stack:
    ; czy nie bedzie zdjecia z pustego stosu?
    cmp edi, [stack_end]
      jb pop_stack_ok
      mov eax, err_st_underflow
      mov ebx, err_st_underflow_len
      call error
  
    pop_stack_ok:
    
    add edi, 4
    mov eax, [pamiec + edi]
  ret


  ; na eax ma wskaznik do komunikatu o bledzie
  ; na ebx ma dlugosc tego komunikatu
  error:
    mov ecx, eax
    mov edx, ebx
    mov eax, SYS_WRITE
    mov ebx, STDERR
    int 80h
    
    mov eax, 1
    call exit
  ret
    
    
  ; na eax ma kod wyjscia
  exit:
    ; !!!
    push eax
      mov eax, newline
      call message_eax
    pop eax
  
    mov ebx, eax
    mov eax, SYS_EXIT
    int 80h
  ret
    

  wypisz_eax:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
      push eax
      push liczba
      call printf
      pop eax
      pop eax
      
      call flush_stdout
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
  ret


  message_eax:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
      push eax
      call printf
      pop eax
      
      call flush_stdout

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
  ret

  ; !!!
  wypisz_stos:
    push eax
    push ecx
    push edx
      mov eax, newline
      call message_eax
      
      mov ecx, [stack_end]
      
      wypisz_stos_petla:
        cmp ecx, edi
        jbe wypisz_stos_petla_koniec
        
        mov eax, [pamiec + ecx]
        call wypisz_eax
      
        sub ecx, 4
        jmp wypisz_stos_petla
      wypisz_stos_petla_koniec:
    pop edx
    pop ecx
    pop eax
  ret
