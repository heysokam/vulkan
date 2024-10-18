//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined cdk_std
#  include "./std.h"
#endif

u32 cdk_makeVersion(const u32 M, const u32 m, const u32 p) { return (u32)(M << 22U) | ((u32)(m << 12U)) | ((u32)(p)); }

Handle newHandle(void) { return (Handle) { .id = 0 }; }

void echof(cstr fmt, ...) {
  va_list args;
  va_start(args, fmt);
  vprintf(fmt, args);
  va_end(args);
}
void err(i32 code, cstr msg) { fprintf(stderr, "Error: %i ->%s\n", code, msg); }
void fail(i32 code, cstr msg) {
  err(code, msg);
  exit(code);
}

cstr* arr_cstr_merge(cstr* one, size_t len1, cstr* two, size_t len2) { // clang-format off
  size_t len    = len1 + len2;
  str*   result = (str*)alloc(len, sizeof(*result));
  // to start pos  from    bytes size
  cpy(result,      one, len1 * sizeof(*one));
  cpy(result+len1, two, len2 * sizeof(*two));
  return (cstr*)result;
} // clang-format on

