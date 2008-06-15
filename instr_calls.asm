; autor: Marian Marek Kedzierski, mk248269
; **************************** INSTR_CALLS.ASM ********************************
; wywolania i powroty z procedur i funkcji

section .data

  call_mesg     db "CALL ", 0 
  ret_mesg      db "RET ", 0 
  retf_mesg     db "RETF ", 0 

section .text
  
  ;; TESTED
  ; wywolanie procedury/funkcji
  INSTR_CALL:
    mov eax, call_mesg
    call message_eax
    
    inc esi ; IP := IP + 1
    
    ; POP B
    call pop_stack 
    mov ebx, eax
    
    ; PUSH IP
    mov eax, esi
    call push_stack 
    
    ; PUSH BP
    mov eax, [REG_BP]
    call push_stack 
    
    ; BP := SP
    mov [REG_BP], edi
    
    ; IP := B
    mov esi, ebx  
    
    mov eax, esi ; !!!
    call wypisz_eax ; !!!
    
  ret 


  ;; TESTED
  ; powrot z procedury
  INSTR_RET:
    mov eax, ret_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    call ret_common
    
  ret 

  
  ; powrot z funkcji
  INSTR_RETF:
    mov eax, retf_mesg
    call message_eax
    
    ; IP := IP + 1
    inc esi 
    
    ; pop C
    call pop_stack
    mov ecx, eax
    
    call ret_common
    
    ; push C
    mov eax, ecx
    call pop_stack
    
  ret 
  
  
  ; czesc wspolna INSTR_RET i INSTR_RETF
  ret_common:
    ; B := [BP]
    mov ebx, [REG_BP]
    and ebx, 0x0000ffff ; zerowanie starszych 16 bitow
    mov ebx, [pamiec + ebx]
    
    ; SP := BP
    mov edi, [REG_BP]
    
    ; pop BP
    call pop_stack
    mov [REG_BP], eax
    
    ; pop IP
    call pop_stack
    mov esi, eax
    
    ; SP := SP + B
    add edi, ebx
  ret
