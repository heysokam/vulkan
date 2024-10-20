//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
/// @fileoverview String Tools
//_____________________________|
// @deps std
#include <string.h>
// @deps cdk
#include "./cstd.h"


/// @descr Returns whether or not {@arg A} is equal to {@arg B}
bool cstr_eq (cstr const A, cstr const B);
/// @descr Returns a duplicate copy of {@arg A}
cstr cstr_dup (cstr const src);
/// @descr Returns a new list of strings by merging the contents of {@arg A} and {@arg B}
cstr_List cstr_List_merge (cstr_List const A, Sz const lenA, cstr_List const B, Sz const lenB);
/// @descr Returns whether or not {@arg val} is contained in the {@arg list} of strings.
bool cstr_List_contains (cstr_List const list, Sz const len, cstr const val);

