#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <assert.h>
#define MAXLEN 100000

/* przyjmuje deskryptor pliku i zwraca dlugosc tego pliku w bajtach */
int get_fsize(const char *path) {
  struct stat st;
  if (stat(path, &st) == -1) {
    fprintf(stderr, "ERROR:");
    fprintf(stderr, " (%d; %s)\n", errno, strerror(errno));
  }
  
  return st.st_size;
}


FILE *f;
unsigned char buf[MAXLEN];
int size;

int main(int argc, char *argv[]) {
  assert(argc == 2);

  f = fopen(argv[1], "rb");
  int i;
  
  size = get_fsize(argv[1]);
  
  fread(buf, 1, size, f);
  
  printf("program : \n");
  for (i=0; i<size; ++i) {
    unsigned int x = buf[i];
    printf("%u ", x);
    if (i%50 == 49) printf("\n");
  }
  printf("\n");
    
  fclose(f);
  
  return 0;
}
