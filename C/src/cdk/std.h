//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#pragma once

#include <stdbool.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
typedef int8_t i8;
typedef int16_t i16;
typedef int32_t i32;
typedef int64_t i64;
typedef unsigned char byte;
typedef float f32;
typedef double f64;
typedef const char *str;

/// Discards the given input.
#define discard(it) (void)(it)

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cdk_std //
//_________________________________//
#include "./std.c"
#endif // cdk_std
