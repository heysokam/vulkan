//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview
//!  Cable connector to all modules of c*vk
//!  c*vk is the code that interacts directly with Vulkan
//________________________________________________________|
#include "./cstd.h"
#include "./cstr.h"
#include "./cvk.h"

#if defined (cvk_SCU)
#include "./cstr.c"
#include "./cvk/cfg.c"
#include "./cvk/debug.c"
#include "./cvk/validation.c"
#include "./cvk/instance.c"
#include "./cvk/device.c"
#endif

