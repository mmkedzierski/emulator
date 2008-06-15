; autor: Marian Marek Kedzierski, mk248269
; **************************** INSTR_VARS.ASM ********************************
; zapisanie i odczytywanie wartosci zmiennych

section .data

  store_mesg    db "STORE ", 0 
  load_mesg     db "LOAD ", 0 

section .text
  
  ;; TESTED
  ; zapisanie wartosci zmiennej
  INSTR_STORE:
    mov eax, store_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop A
    call pop_stack
    
    ; wyzerowanie starszych 16 bitow w A
    and eax, 0x0000ffff
    
    ; push [A]
    mov eax, [pamiec + eax]
    call wypisz_eax ; !!!
    call push_stack
    
  ret 


  ;; TESTED
  ; przypisanie zmiennej
  INSTR_LOAD:
    mov eax, load_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; POP A
    call pop_stack
    
    ; wyzerowanie starszych 16 bitow w A
    and eax, 0x0000ffff
    
    ; POP [A]
    lea ebx, [pamiec + eax]
    call pop_stack
    mov [ebx], eax
    
  ret 
