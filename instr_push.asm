; autor: Marian Marek Kedzierski, mk248269
; **************************** INSTR_PUSH.ASM ********************************
; instrukcje PUSH

section .data

  push_mesg     db "PUSH ", 0
  push_bp_mesg  db "PUSH_BP ", 0
  push_sp_mesg  db "PUSH_SP ", 0
  
section .text

  ;; TESTED
  ; zapisanie stalej 32-bitowej
  INSTR_PUSH:
    mov eax, push_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; PUSH [IP]
    mov eax, [pamiec + esi]
    call wypisz_eax ; !!!
    call push_stack
    
    ; IP := IP + 4
    add esi, 4
  
  ret 


  ; zapisanie BP na stosie
  INSTR_PUSH_BP:
    mov eax, push_bp_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; PUSH BP
    mov eax, [REG_BP]
    call push_stack
    
  ret 


  ; zapisanie SP na stosie
  INSTR_PUSH_SP:
    mov eax, push_sp_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; PUSH SP
    mov eax, edi
    call push_stack
    
  ret 
