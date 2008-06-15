#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>

/* przyjmuje deskryptor pliku i zwraca dlugosc tego pliku w bajtach */
int get_file_size(int fd) {
  struct stat st;
  if (fstat(fd, &st) == -1) {
    fprintf(stderr, "ERROR:");
    fprintf(stderr, " (%d; %s)\n", errno, strerror(errno));
  }
  
  return st.st_size;
}

void flush_stdout() {
  fflush(stdout);
}

