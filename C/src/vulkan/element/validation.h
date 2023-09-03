//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#pragma once
#include "./base.h"

#if debug
extern cstr validationLayers[Max_VulkanLayers];
#else
extern cstr const* validationLayers;
#endif


bool cvk_validate_chkSupport(void);
