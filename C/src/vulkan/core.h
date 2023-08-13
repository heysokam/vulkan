//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#pragma once
// External dependencies
#include <vulkan/vulkan.h>
// cdk dependencies
#include "../cdk/std.h"
// cvk dependencies
#include "./elements.h"

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cvk_vulkan //
//_________________________________//
#include "./vulkan.c"
#endif // cvk_vulkan
