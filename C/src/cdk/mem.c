//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./mem.h"

void* alloc(size_t count, size_t bytes) {
  void* result = allo(bytes * count);
  memset(result, 0, bytes * count);
  return result;
}

