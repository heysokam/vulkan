//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
// External dependencies
#include "../cdk/std.h"
#include <GLFW/glfw3.h>

/// Contains the window context and its properties.
typedef struct cWindow_s {
  GLFWwindow *ct;
  u32 width;
  u32 height;
  str title;
} cWindow;

/// Function input arguments
typedef struct args_w_init_s {
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
} w_init_args;
//______________________________________
// External interface
//____________________________

/// Error callback for GLFW
void w_error(i32 code, const char *descr);
/// Resize callback for GLFW
void w_resize(GLFWwindow *window, int width, int height);
/// Initializes and returns a window.
cWindow w_init(w_init_args in);
/// Gets the current size of the given window, and stores it in its .size field.
void w_updateSize(cWindow win);
/// Runs the logic required for rendering one frame with this window.
void w_update(cWindow win);
/// Returns true if the window has been marked for closing.
bool w_close(cWindow w);
/// Terminates the window.
void w_term(cWindow w);

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cvk_window //
//_________________________________//
#include "./window.c"
#endif // cvk_window
