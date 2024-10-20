//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./cstd.h"

void echof(cstr fmt, ...) {
  va_list args;
  va_start(args, fmt);
  vprintf(fmt, args);
  va_end(args);
}
void err(i32 code, cstr msg) { fprintf(stderr, "Error: %i ->%s\n", code, msg); }
[[noreturn]] void fail(i32 code, cstr msg) {
  err(code, msg);
  exit(code);
}

cdk_Version cdk_version_new(u32 const M, u32 const m, u32 const p) { return (u32)(M << 22U) | ((u32)(m << 12U)) | ((u32)(p)); }

cdk_Handle cdk_handle_new(void) { return (cdk_Handle) { .id = 0 }; }

