#include "./mem.h"

void* alloc(size_t bytes, size_t count) {
  void* result = allo(bytes * count);
  memset(result, 0, bytes * count);
  return result;
}

