//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
#include <string.h>
#include <stdlib.h>

/// Allocates the given bytes `size`, and returns a pointer to their address.
/// Does NOT zero data on creation. Alias for malloc
#define allo malloc

/// Allocates `count` items of the given `bytes` size, and returns a pointer to their address.
/// Zeroes the data on creation.
void* alloc(size_t count, size_t bytes);

/// Copies `bytes` size of `src` into `trg`.
/// Alias for memcpy
#define cpy memcpy
