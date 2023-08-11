//:___________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
//:___________________________________________________
// External dependencies
#include <GLFW/glfw3.h>
#include "../lib/std.h"


/// Contains the window context and its properties.
typedef struct cWindow_s {
  GLFWwindow* ct    = NULL;
  UVec2       size  = glm::uvec2(940, 560);
  str         title = "Cendk | Engine";
} cWindow;

/// Function input arguments
namespace args {  // clang-format off
struct init {
  // Window config
  str title; u32 width; u32 height; bool resize;
  glfw::cb::resize resizeCB; glfw::cb::error error;  // General callbacks
  // Input callbacks
  glfw::cb::key key; glfw::cb::mousePos mousePos; glfw::cb::mouseBtn mouseKey; glfw::cb::scroll mouseScroll;
  };  /// w::init( ... )
}  // clang-format on

//______________________________________
// External interface
//____________________________

/// Error callback for GLFW
void w_error(i32 code, const char* descr);
/// Resize callback for GLFW
void w_resize(GLFWwindow* window, int width, int height);
/// Initializes and returns a window.
cWindow w_init(args::init in);
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
#if defined cvk_window  //
//_________________________________//
#  include "./window.c"
#endif  // cvk_window

