; autor: Marian Marek Kedzierski, mk248269
; **************************** INSTR_BIT.ASM ********************************
; operacje bitowe

section .data

  and_mesg      db "AND ", 0 
  or_mesg       db "OR ", 0 
  not_mesg      db "NOT ", 0 

section .text
  
  ; koniunkcja bitowa
  INSTR_AND:
    mov eax, and_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; push (A and B)
    and eax, ebx
    call push_stack
    
  ret 


  ; alternatywa bitowa
  INSTR_OR:
    mov eax, or_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; push (A or B)
    or eax, ebx
    call push_stack
    
  ret 

  
  ; negacja bitowa
  INSTR_NOT:
    mov eax, not_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop A
    call pop_stack
    
    call wypisz_eax ; !!!
    
    ; push (not A)
    not eax
    call push_stack
    
  ret 
