//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
// External dependencies
#include <vulkan/vulkan.h>
// cdk dependencies
#include "../cdk/std.h"
// cvk dependencies
#include "./cfg.h"
#include "./elements.h"

typedef struct cvk_init_args_s {
  // Application Information
  str appName;
  u32 appVers;
  str engineName;
  u32 engineVers;
  // Vulkan Config
  VkAllocator* allocator;
} cvk_init_args;

typedef struct Vulkan_s {
  VkInstance        instance;
  VkDebugMessenger* dbg;
  VkAllocator*      allocator;
} Vulkan;

/// Initializes and returns a Vulkan renderer object.
Vulkan cvk_init(cvk_init_args in);
/// Runs the logic required for rendering one frame
void cvk_update(Vulkan* vk);
/// Terminates the renderer.
void cvk_term(Vulkan* vk);

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cvk_vulkan  //
//_________________________________//
#  include "./vulkan.c"
#endif  // cvk_vulkan
