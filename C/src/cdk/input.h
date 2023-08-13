//:___________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
//:___________________________________________________
#pragma once
#include "./std.h"
#include <GLFW/glfw3.h>

/// GLFW Keyboard Input Callback
void i_key(GLFWwindow* win, int key, int code, int action, int mods);

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cdk_input //
//_________________________________//
#include "./input.c"
#endif // cdk_input
