//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// Base module : Imported by all files in this folder.  |
//______________________________________________________|
#pragma once
// External dependencies
#include <vulkan/vulkan.h>
// c*dk dependencies
#include "../../cdk/std.h"
#include "../../cdk/mem.h"
// c*vk dependencies
#include "../alias.h"
#include "../cfg.h"
#include "../max.h"

// TODO: Error management
#define chk(a, b) discard(a)

/// Value added to all Component IDs, to avoid conflict with most known error codes
#define ComponentOffset 100

/// ID of each c*vk component. Used for error codes, and other identification handles.
typedef enum Component_ID {
  Validation = ComponentOffset + 1,
  Instance,
  Device,
  Component_Force32 = 0x7FFFFFFF,
} Component;

