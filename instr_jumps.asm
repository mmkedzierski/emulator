; autor: Marian Marek Kedzierski, mk248269
; **************************** INSTR_JUMPS.ASM ********************************
; skoki

section .data

  jmp_mesg    db "JMP ", 0 
  jc_mesg     db "JC ", 0 

section .text
  
  ; skok
  INSTR_JMP:
    mov eax, jmp_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; POP IP
    call pop_stack
    mov esi, eax
    
  ret 


  ; skok warunkowy
  INSTR_JC:
    mov eax, jc_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; POP B
    call pop_stack
    mov ebx, eax
    
    ; POP C
    call pop_stack
    mov ecx, eax
    
    ; if ((C and 1) = 1) then IP := B
    test ecx, 1
      jz INSTR_JC_dalej
      mov esi, ebx
    
    INSTR_JC_dalej:
    
  ret 
