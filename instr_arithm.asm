; autor: Marian Marek Kedzierski, mk248269
; **************************** INSTR_ARITHM.ASM ********************************
; operacje arytmetyczne

section .data

  add_mesg     db "ADD ", 0 
  sub_mesg     db "SUB ", 0 
  mul_mesg     db "MUL ", 0 
  div_mesg     db "DIV ", 0 

  ; komunikaty o bledach
  err_division_by_zero          db    "ERROR: division by zero, exiting", 10, 0
  err_division_by_zero_len      equ   $ - err_division_by_zero

section .text
  
  ; dodawanie
  INSTR_ADD:
    mov eax, add_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; push (A + B)
    call wypisz_eax ; !!!
    add eax, ebx
    call wypisz_eax ; !!!
    call push_stack
    
  ret 


  ;; TESTED
  ; odejmowanie
  INSTR_SUB:
    mov eax, sub_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; push (A - B)
    sub eax, ebx
    call push_stack
    
  ret 

  
  ; mnozenie
  INSTR_MUL:
    mov eax, mul_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; push (A * B)
    mul ebx
    call push_stack
    
  ret 


  ; dzielenie
  INSTR_DIV:
    mov eax, div_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; jesli B = 0 to zglos blad
    test ebx, ebx
      jz INSTR_DIV_error
      jmp INSTR_DIV_ok
      
    INSTR_DIV_error:
      mov eax, err_division_by_zero
      mov ebx, err_division_by_zero_len
      call error
    
    INSTR_DIV_ok:
    
    ; push (A / B)
    xor edx, edx
    div ebx
    call push_stack
    
  ret 
