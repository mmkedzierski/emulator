# autor: Marian Marek Kedzierski, mk248269
c_programs = compiler reader
c_objects = pomocnicze_c
asm_files = emulator.asm pomocnicze.asm instr_sys.asm instr_push.asm instr_vars.asm instr_jumps.asm instr_calls.asm instr_arithm.asm instr_bit.asm instr_test.asm 
emulated_program = primes.bin

run : emulator $(c_programs)
	./compiler
	./reader $(emulated_program)
	./emulator $(emulated_program) > output.txt
	
$(c_programs) : % : %.c
	gcc $^ -o $@
	
$(c_objects) : % : %.c
	gcc -c $^ -o $@

emulator : compound.o $(c_objects)
	gcc $^ -o $@

compound.asm : $(asm_files) 
	cat $(asm_files) > $@

compound.o : %.o : %.asm
	nasm -f elf $^ -o $@


.PHONY: clean small_clean 


small_clean:
	rm -f *.o 

clean:  small_clean
	rm *~ $(c_programs) emulator compound.asm output.txt
