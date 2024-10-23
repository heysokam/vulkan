//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./cstd.h"

//______________________________________
// @section Logging
//____________________________
void echof(cstr fmt, ...) {
  va_list args;
  va_start(args, fmt);
  vprintf(fmt, args);
  va_end(args);
}
void err(i32 code, cstr msg) { fprintf(stderr, "Error: %i ->%s\n", code, msg); }
[[noreturn]] void fail(i32 code, cstr msg) { err(code, msg); exit(code); }

//______________________________________
// @section Version
//____________________________
cdk_Version cdk_version_new(u32 const M, u32 const m, u32 const p) { return (u32)(M << 22U) | ((u32)(m << 12U)) | ((u32)(p)); }


//______________________________________
// @section Handle
//____________________________
cdk_Handle cdk_handle_new(void) { return (cdk_Handle){.id= 0}; }


//______________________________________
// @section Optional types
//____________________________
Ou32 Ou32_some (u32 const val) { return (Ou32){.hasValue= true, .value= val}; }
Ou32 Ou32_none (void) { return (Ou32){.hasValue= false, .value= (u32)-1}; }
void Ou32_set (Ou32* const it, u32 const val) { it->hasValue = true; it->value = val; }
bool Ou32_eq (Ou32 const A, Ou32 const B) {  return A.hasValue && B.hasValue && A.value == B.value; }


//______________________________________
/// @section Type Tools: Floats
//____________________________
bool f32_inRange (f32 const val, f32 const minv, f32 const maxv) {  return val >= minv && val <= maxv;}
bool f32_zeroToOne (f32 const val) {  return f32_inRange(val, 0.0, 1.0);}


//______________________________________
/// @section Type Tools: Integers Unsigned
//____________________________
const u8 u8_high = (u8)(~0);
const u16 u16_high = (u16)(~0);
const u32 u32_high = (u32)(~0);
const u64 u64_high = (u64)(~0);
u32 u32_min (u32 const val, u32 const m) {  return (val < m) ? m : val;}
u32 u32_max (u32 const val, u32 const M) {  return (val > M) ? M : val;}
u32 u32_clamp (u32 const val, u32 const m, u32 const M) {  return u32_max(u32_min(val, m), M);}

//______________________________________
/// @section Type Tools: Integers Signed
//____________________________
const i8  i8_high  = (i8)(~0);
const i16 i16_high = (i16)(~0);
const i32 i32_high = (i32)(~0);
const i64 i64_high = (i64)(~0);
i32 i32_min (i32 const val, i32 const m) {  return (val < m) ? m : val;}
i32 i32_max (i32 const val, i32 const M) {  return (val > M) ? M : val;}
i32 i32_clamp (i32 const val, i32 const m, i32 const M) {  return i32_max(i32_min(val, m), M);}

