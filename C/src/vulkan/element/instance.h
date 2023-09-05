//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
#include "./base.h"
#include "./validation.h"

/// Gets a list of extensions, by merging our desired list with the ones required by the system.
cstr* cvk_instance_getExtensions(u32* count);

/// List of arguments given to the `cvk_instance_create` function.
typedef struct cvk_instance_create_args_s {
  str                  appName;
  u32                  appVers;
  str                  engineName;
  u32                  engineVers;
  VkDebugMessengerCfg* debugCfg;
  VkAllocator*         allocator;
} cvk_instance_create_args;

/// Creates a new VkInstance object, including all of its required properties.
VkInstance cvk_instance_create(cvk_instance_create_args in);
