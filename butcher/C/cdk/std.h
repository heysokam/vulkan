//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
// C++ Support
#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>
#include <stdint.h>
typedef uint8_t       u8;
typedef uint16_t      u16;
typedef uint32_t      u32;
typedef uint64_t      u64;
typedef int8_t        i8;
typedef int16_t       i16;
typedef int32_t       i32;
typedef int64_t       i64;
typedef unsigned char byte;
typedef float         f32;
typedef double        f64;
typedef char*         str;
typedef const char*   cstr;
typedef u8            TODO;

//__________________________________________________________
// General Purpose
//______________________________________

// clang-format off
typedef struct Handle_s { u32 id; } Handle;
// clang-format on

/// Creates a new Handle object
Handle newHandle(void);
/// Discards the given input.
#define discard(it) (void)(it)


//__________________________________________________________
// Arrays
//______________________________________
#include <stddef.h>

/// Returns the size of the input array
#define arr_len(arr) (sizeof(arr)) / (sizeof(arr[0]))
/// Combines the two given cstr arrays into a single one, and returns it.
/// Allocates the memory that stores the information.
cstr* arr_cstr_merge(cstr* one, size_t len1, cstr* two, size_t len2);

// #define arr_merge(a1,s1, a2,s2)
//_____________________________
// TODO: Array Concatenation  |
// size_t array1Size = 42;
// T* array1 = malloc(sizeof(T) * array1Size);
// size_t array2Size = 69;
// T* array2 = malloc(sizeof(T) * array2Size);
//
//
// T* array3 = malloc(sizeof(T) * (array1Size + array2Size));
// memcpy(array3, array1, sizeof(T) * array1Size);
// memcpy(array3 + array1Size, array2, sizeof(T) * array2Size);
//____________________________|


//__________________________________________________________
// Strings: cstr
//______________________________________

#include "./mem.h"
/// Compares two strings and returns a boolean of whether or not they are the same
#define str_equal(a,b) (bool)(strcmp((a),(b)) == 0)
cstr* arr_cstr_merge(cstr* a, size_t len_a, cstr* b, size_t len_b);


#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
/// Prints the formatted varargs message to console.
void echof(cstr fmt, ...);
/// Echoes an error message to stderr.
void err(i32 code, cstr msg);
/// Echoes an error message to stderr, and exits the app.
void fail(i32 code, cstr msg);
/// Generates a version number, in Vulkan style
u32 cdk_makeVersion(const u32 M, const u32 m, const u32 p);


/// Systems aliasing
#if defined __WIN32
#  define windows
#endif
#if defined __linux__
// #define linux
#endif
#if defined __APPLE__
#  define macosx
#endif

/// Build Mode aliasing
#if defined NDEBUG || !defined DEBUG
#define cdk_release true
#define cdk_debug false
#elif defined DEBUG
#define cdk_release false
#define cdk_debug true
#endif

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cdk_std  //
//_________________________________//
#  include "./std.c"
#endif  // cdk_std


//:: C++ Support
#ifdef __cplusplus
}
#endif
