//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
// External dependencies
#include <GLFW/glfw3.h>
// cdk dependencies
#include "./std.h"

/// Contains the window context and its properties.
typedef struct cWindow_s {
  GLFWwindow *ct;
  u32 width;
  u32 height;
  str title;
} cWindow;

/// Dummy Handle for the input functions
typedef Handle cInput;

/// System Object. Contains the Window and Input objects.
typedef struct System_s {
  cWindow win;
  cInput  inp;
} System;


//______________________________________
// Function input arguments
//____________________________

typedef struct w_init_args_s {
  // Window config
  str title;
  u32 width;
  u32 height;
  bool resize;
  // General callbacks
  GLFWframebuffersizefun resizeCB;
  GLFWerrorfun error;
} w_init_args;

typedef struct i_init_args_s {
  // Input callbacks
  GLFWkeyfun         key;
  GLFWcursorposfun   mousePos;
  GLFWmousebuttonfun mouseBtn;
  GLFWscrollfun      mouseScroll;
} i_init_args;

typedef struct csys_init_args_s {
  w_init_args win;
  i_init_args inp;
} csys_init_args;


//______________________________________
// Callbacks
//____________________________

/// Error callback for GLFW
void w_error(i32 code, const char *descr);
/// Resize callback for GLFW
void w_resize(GLFWwindow *window, int width, int height);
/// GLFW Keyboard Input Callback
void i_key(GLFWwindow* win, int key, int code, int action, int mods);


//______________________________________
// External interface
//____________________________

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

/// Initializes and returns an Input handle.
cInput i_init(cWindow win, i_init_args in);
/// Runs the logic required for getting proper inputs from the System.
void i_update(cInput i);

/// Initializes and returns a System object
System csys_init(csys_init_args in);
/// Runs the logic required for updating the Window and Input of the System.
void csys_update(System* sys);
/// Returns true if the System has been marked for closing.
bool csys_close(System* sys); 
/// Terminates the System.
void csys_term(System* sys);

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cvk_system //
//_________________________________//
#include "./window.c"
#include "./input.c"
#endif // cvk_system
