//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

typedef uint8_t     byte;
typedef uint8_t     u8;
typedef uint16_t    u16;
typedef uint32_t    u32;
typedef uint64_t    u64;
typedef uintptr_t   uP;
typedef size_t      Sz;
typedef int8_t      i8;
typedef int16_t     i16;
typedef int32_t     i32;
typedef int64_t     i64;
typedef intptr_t    iP;
typedef float       f32;
typedef double      f64;
typedef char*       str;
typedef char const* cstr;
typedef cstr*       cstr_List;
typedef u8          TODO;

//______________________________________
// @section Growable Arrays
//____________________________
typedef struct Garr Garr;
struct Garr {
  Sz len; Sz cap;
  void* data;
};
typedef struct ByteBuffer ByteBuffer;
struct ByteBuffer {
  Sz len; Sz cap;
  byte* data;
};


//______________________________________
// @section General Purpose
//____________________________

/// @descr Discards the given input.
#define discard(it) (void)(it)

//______________________________________
// @section Handles
//____________________________

// clang-format off
typedef struct cdk_Handle_s { u32 id; } cdk_Handle;
// clang-format on

/// @descr Creates a new Handle object
cdk_Handle cdk_handle_new(void);

//______________________________________
// @section Arrays
//____________________________
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


//______________________________________
// @section Strings: cstr
//____________________________
#include "./cmem.h"
/// @descr Compares two strings and returns a boolean of whether or not they are the same
#define str_equal(a,b) (bool)(strcmp((a),(b)) == 0)
cstr* arr_cstr_merge(cstr* a, size_t len_a, cstr* b, size_t len_b);


//______________________________________
// @section Logging
//____________________________
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <assert.h>
/// @descr Prints the formatted varargs message to console.
void echof(cstr fmt, ...);
/// @descr Echoes an error message to stderr.
void err(i32 code, cstr msg);
/// @descr Echoes an error message to stderr, and exits the app.
[[noreturn]] void fail(i32 code, cstr msg);


//______________________________________
// @section Version
//____________________________
/// @descr Represents a version number (compatible with Vulkan)
typedef u32 cdk_Version;
/// @descr Generates a version number (compatible with Vulkan)
cdk_Version cdk_version_new(u32 const M, u32 const m, u32 const p);


//______________________________________
// @section Optional types
//____________________________
typedef struct Ou32 { u32 value; bool hasValue; u8 priv_pad1; u16 priv_pad2; } Ou32;
Ou32 Ou32_some (u32 const val);
Ou32 Ou32_none (void);
void Ou32_set (Ou32* const it, u32 const val);
bool Ou32_eq (Ou32 const A, Ou32 const B);


//______________________________________
// @section Type Tools: Floats
//____________________________
bool f32_inRange (f32 const val, f32 const minv, f32 const maxv);
bool f32_zeroToOne (f32 const val);


//______________________________________
// @section Type Tools: Integers Unsigned
//____________________________
u32 u32_min (u32 const val, u32 const m);
u32 u32_max (u32 const val, u32 const M);
u32 u32_clamp (u32 const val, u32 const m, u32 const M);
extern const u8  u8_high;
extern const u16 u16_high;
extern const u32 u32_high;
extern const u64 u64_high;

//______________________________________
// @section Type Tools: Integers Signed
//____________________________
extern const i8  i8_high;
extern const i16 i16_high;
extern const i32 i32_high;
extern const i64 i64_high;
i32 i32_min (i32 const val, i32 const m);
i32 i32_max (i32 const val, i32 const M);
i32 i32_clamp (i32 const val, i32 const m, i32 const M);


//______________________________________
// @section Systems aliasing
//____________________________
#if defined __WIN32
#  define windows
#endif
#if defined __linux__
// #define linux
#endif
#if defined __APPLE__
#  define macosx
#endif

//______________________________________
// @section Build Mode aliasing
//____________________________
#if defined NDEBUG || !defined DEBUG
#define cdk_release true
#define cdk_debug false
#elif defined DEBUG
#define cdk_release false
#define cdk_debug true
#endif

