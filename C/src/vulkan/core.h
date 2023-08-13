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

typedef struct args_cvk_init_s {
  // Window config
  str title;
  u32 width;
  u32 height;
  bool resize;
  // General callbacks
  GLFWframebuffersizefun resizeCB;
  GLFWerrorfun error;
  // Input callbacks
  GLFWkeyfun key;
  GLFWcursorposfun mousePos;
  GLFWmousebuttonfun mouseBtn;
  GLFWscrollfun mouseScroll;
  // Application Information
  str appName;
  u32 appVers;
  str engineName;
  u32 engineVers;
} cvk_init_args;

typedef struct Vulkan_s {
  cWindow win;
  VkInstance instance;
} Vulkan;

/// Initializes and returns a Vulkan renderer object.
Vulkan cvk_init(cvk_init_args in);
/// Runs the logic required for rendering one frame
void cvk_update(Vulkan *vk);
/// Returns true if the renderer has been marked for closing.
bool cvk_close(Vulkan *vk);
/// Terminates the renderer.
void cvk_term(Vulkan *vk);

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cvk_vulkan //
//_________________________________//
#include "./vulkan.c"
#endif // cvk_vulkan
