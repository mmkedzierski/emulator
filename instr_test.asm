; autor: Marian Marek Kedzierski, mk248269
; **************************** INSTR_TEST.ASM ********************************
; porownania

section .data

  eq_mesg       db "EQ ", 0 
  ab_mesg       db "AB ", 0
  ae_mesg       db "AE ", 0

section .text
  
  ; test czy rowne
  INSTR_EQ:
    mov eax, eq_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; if (A = B) then push 1 else push 0
    cmp eax, ebx
      jz INSTR_EQ_push1
      xor eax, eax
      call push_stack ; push 0
      jmp INSTR_EQ_koniec
      
    INSTR_EQ_push1:
    mov eax, 1
    call push_stack
    
    INSTR_EQ_koniec:
  ret 


  ; test czy wieksze
  INSTR_AB:
    mov eax, ab_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; if (A > B) then push 1 else push 0
    cmp eax, ebx
      ja INSTR_AB_push1
      xor eax, eax
      call push_stack ; push 0
      jmp INSTR_AB_koniec
      
    INSTR_AB_push1:
    mov eax, 1
    call push_stack
    
    INSTR_AB_koniec:
  ret 

  
  ;; TESTED
  ; test czy wieksze lub rowne
  INSTR_AE:
    mov eax, ae_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop B
    call pop_stack
    mov ebx, eax
    
    ; pop A
    call pop_stack
    
    ; if (A >= B) then push 1 else push 0
    cmp eax, ebx
      jae INSTR_AE_push1
      xor eax, eax
      call push_stack ; push 0
      jmp INSTR_AE_koniec
      
    INSTR_AE_push1:
    mov eax, 1
    call push_stack
    
    INSTR_AE_koniec:
  ret 
