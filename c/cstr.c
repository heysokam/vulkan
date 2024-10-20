//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./cstr.h"

bool cstr_eq (cstr const A, cstr const B) {
  return strcmp(A, B) == 0;
}

cstr cstr_dup (cstr const src) {
  /// Duplicates the `src` string by allocating a new copy of its data and returning it.
  /// Port of musl/strdup | musl.libc.org | MIT License
  Sz const len = strlen(src) + 1;
  str result = (str)malloc(len * sizeof(char));
  if (!result) return NULL;
  return memcpy((void*)result, src, len);
}

cstr_List cstr_List_merge (cstr_List const A, Sz const lenA, cstr_List const B, Sz const lenB) {
  /// Combines the two given cstr arrays into a single one, and returns it.
  /// Allocates the memory that stores the information.
  cstr_List result = calloc(lenA + lenB, sizeof(cstr));
  memcpy(result, A, lenA * sizeof(*A));
  memcpy(result + lenA, B, lenB * sizeof(*B));
  return result;
}

bool cstr_List_contains (cstr_List const arr, Sz const len, cstr const val) {
  /// Returns true if the array of strings `arr` contains the given `val` string
  for(size_t id = 0; id < len; ++id) {
    if (cstr_eq(arr[id], val)) return true;
  }
  return false;
}

