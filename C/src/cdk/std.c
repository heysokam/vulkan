//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#if !defined cdk_std
#include "./std.h"
#endif

u32 cdk_makeVersion(const u32 M, const u32 m, const u32 p) {
  return (u32)(M << 22U) | ((u32)(m << 12U)) | ((u32)(p));
}

Handle newHandle(void) { return (Handle) { .id = 0 }; }
