#include <stdio.h>
#include <assert.h>
#define MAXLEN 1000000

FILE *f;
unsigned char buf[MAXLEN];
char op[100];
int n;
FILE *fin, *fout;

int main(int argc, char *argv[]) {
/*  int i;
  assert(argc == 2);
  sprintf(fin_name, "%s.src", argv[1]);
  sprintf(fout_name, "%s.bin", argv[1]);
  
  fin = fopen(fin_name, "r");
  fout = fopen(fout_name, "wb");
  
  
  i = 0;
  int num;
  while (fscanf(fin, "%s", &op) == 1) {
    if (!strcmp(op, "SYS"))           buf[i++] = 0;
    else if (!strcmp(op, "PUSH"))     buf[i++] = 1; 
    else if (!strcmp(op, "PUSH_BP"))  buf[i++] = 2; 
    else if (!strcmp(op, "PUSH_SP"))  buf[i++] = 3; 
    else if (!strcmp(op, "STORE"))    buf[i++] = 4; 
    else if (!strcmp(op, "LOAD"))     buf[i++] = 5; 
    else if (!strcmp(op, "JMP"))      buf[i++] = 6; 
    else if (!strcmp(op, "CALL"))     buf[i++] = 7; 
    else if (!strcmp(op, "RET"))      buf[i++] = 8; 
    else if (!strcmp(op, "RETF"))     buf[i++] = 9; 
    else if (!strcmp(op, "ADD"))      buf[i++] = 10; 
    else if (!strcmp(op, "SUB"))      buf[i++] = 11; 
    else if (!strcmp(op, "MUL"))      buf[i++] = 12; 
    else if (!strcmp(op, "DIV"))      buf[i++] = 13; 
    else if (!strcmp(op, "AND"))      buf[i++] = 14; 
    else if (!strcmp(op, "OR"))       buf[i++] = 15; 
    else if (!strcmp(op, "NOT"))      buf[i++] = 16; 
    else if (!strcmp(op, "EQ"))       buf[i++] = 17; 
    else if (!strcmp(op, "AB"))       buf[i++] = 18; 
    else if (!strcmp(op, "AE"))       buf[i++] = 19; 
    else if (!strcmp(op, "JC"))       buf[i++] = 20; 
    else {
      // liczba
      num = atoi(op);
      *(((int *) buf) + i) = num;
      i += 4;
    }
  }

  n = i;*/
  
  
  n = 0;
  
  buf[n++] = 1; // push 10 - arg
  buf[n++] = 2;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  
  buf[n++] = 1; // push 11
  buf[n++] = 11;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 7; // call 11
   
  // fun
    buf[n++] = 1; // push 4 -- 1 argument
    buf[n++] = 4;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    
    buf[n++] = 3; // push sp
    buf[n++] = 1; // push 12
    buf[n++] = 12; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 10; // add sp + 12
    buf[n++] = 4; // store arg
    
    buf[n++] = 1; // push 1
    buf[n++] = 1; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 11; // sub arg - 1
    
    // jesli arg - 1 > 0 then call rec else zwroc 1
    buf[n++] = 1; // push 0
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 18; // AB: arg - 1 > 0?
    buf[n++] = 1; // push 48
    buf[n++] = 48; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 20; // JC ? -> call
    buf[n++] = 1; // push 64
    buf[n++] = 64; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0;
    buf[n++] = 6; // JMP ?? -> ret 1
    
    // ? = 48
    buf[n++] = 1; // push 11
    buf[n++] = 11; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 7; // call 11
    buf[n++] = 3; // push sp
    buf[n++] = 1; // push 12
    buf[n++] = 12; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 10; // add sp + 12
    buf[n++] = 4;  // store arg
    buf[n++] = 12; // MUL
    buf[n++] = 9; // RETF
    
    // ?? = 64
    buf[n++] = 1; // push 1
    buf[n++] = 1; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 0; 
    buf[n++] = 9; // RETF
    
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0; // sys exit
    
    

  
/*  
  // inicjalizacja
  buf[n++] = 1; // push 'g'
  buf[n++] = 'z';
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 1; // push 100
  buf[n++] = 100;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 5; // load [100] := 'g'
  
  // wywolanie funkcji
  buf[n++] = 1; // push 23
  buf[n++] = 23;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 7; // call 23
  
  // koniec programu
  buf[n++] = 1; // push 0
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0;
  buf[n++] = 0; // sys exit
  
  // funkcja
    buf[n++] = 1; // push 0 - brak zmiennych lokalnych
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 1; // push 1
    buf[n++] = 1;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 1; // push 96
    buf[n++] = 96;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 16; // NOT
    buf[n++] = 16; // NOT
    buf[n++] = 5; // load [96] := 1
    
    // wypisz [100]
    buf[n++] = 1; // push 96
    buf[n++] = 96;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 1; // push 1
    buf[n++] = 1;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0; // sys write [96]
    
    // zmniejsz [100] o 1
    buf[n++] = 1; // push 100
    buf[n++] = 100;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 4; // store [100]
    buf[n++] = 1; // push 1
    buf[n++] = 1;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 11;  // sub: [100] - 1
    buf[n++] = 1; // push 100
    buf[n++] = 100;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 5; // load [100] := [100] - 1
    
    // jesli [100] >= 'a' to powtorz funkcje
    buf[n++] = 1; // push 100
    buf[n++] = 100;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 4; // store [100]
    buf[n++] = 1; // push 'a'
    buf[n++] = 'A';
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 19; // AE: czy [100] >= 'a'
    buf[n++] = 1; // push 96
    buf[n++] = 96;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 16; // NOT
    buf[n++] = 20; // JC: jesli [100] < 'a' to juz nie wywoluj funkcji
    buf[n++] = 1; // push 23
    buf[n++] = 23;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 0;
    buf[n++] = 7; // call 23
    
  buf[n++] = 8; // ret*/
  
  
  
  
  fout = fopen("program.bin", "wb");
  
  fwrite(buf, n, 1, fout);
//   fclose(fin);
  fclose(fout);
  
  return 0;
}
