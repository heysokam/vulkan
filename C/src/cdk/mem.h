#pragma once
#include <string.h>
#include <stdlib.h>

/// Allocates the given bytes `size`, and returns a pointer to their address.
/// Does NOT zero data on creation. Alias for malloc
#define allo malloc

/// Allocates `count` items of the given `bytes` size, and returns a pointer to their address.
/// Zeroes the data on creation.
void* alloc(size_t count, size_t bytes);
