//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview
//! TODO: External zvk_name_fn API for C
//_____________________________________________________|
const C = struct {
  export fn zvk_tmp_add  (a :c_int, b :c_int) c_int { return a + b; }
  export fn zvk_tmp_add2 (a :  u32, b :  u32)   u32 { return a + b; }
}; comptime { _ = &C; } // Force exports to be analyzed
//______________________________________

