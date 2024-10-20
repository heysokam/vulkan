
//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
// @deps External
#include <GLFW/glfw3.h>
// @deps cdk
#include "./cstd.h"


/// @descr Graphics API Selection option
typedef enum csys_api_e { csys_api_none, csys_api_opengl  } csys_api;
#define csys_api_vulkan csys_api_none
#define csys_api_wgpu csys_api_none

/// @descr Contains the window context and its properties.
typedef struct csys_Window_s {
  GLFWwindow* ct;
  u32         width;
  u32         height;
  str         title;
} csys_Window;

/// @descr Dummy Handle for the input functions
typedef cdk_Handle csys_Input;

/// @descr System Object. Contains the Window and Input objects.
typedef struct csys_System_s {
  csys_api api;
  csys_Window win;
  csys_Input  inp;
} csys_System;

//______________________________________
// @section Function input arguments
//____________________________

typedef struct w_init_args_s {
  // Window config
  str  title;
  u32  width;
  u32  height;
  bool resize;
  // General callbacks
  GLFWframebuffersizefun resizeCB;
  GLFWerrorfun           error;
} w_init_args;

typedef struct i_init_args_s {
  // Input callbacks
  GLFWkeyfun         key;
  GLFWcursorposfun   mousePos;
  GLFWmousebuttonfun mouseBtn;
  GLFWscrollfun      mouseScroll;
} i_init_args;

typedef struct csys_init_args_s {
  csys_api    api;
  w_init_args win;
  i_init_args inp;
} csys_init_args;


//______________________________________
// @section Callbacks
//____________________________

/// @descr Error callback for GLFW
void w_error(i32 code, const char *descr);
/// @descr Resize callback for GLFW
void w_resize(GLFWwindow *window, int width, int height);
/// @descr GLFW Keyboard Input Callback
void i_key(GLFWwindow* win, int key, int code, int action, int mods);


//______________________________________
// @section External interface
//____________________________

/// @descr Initializes and returns a window.
csys_Window w_init(w_init_args in, csys_api api);
/// @descr Gets the current size of the given window, and stores it in its .size field.
void w_updateSize(csys_Window win);
/// @descr Runs the logic required for rendering one frame with this window.
void w_update(csys_Window win, csys_api api);
/// @descr Returns true if the window has been marked for closing.
bool w_close(csys_Window w);
/// @descr Terminates the window.
void w_term(csys_Window w);

/// @descr Initializes and returns an Input handle.
csys_Input i_init(csys_Window win, i_init_args in);
/// @descr Runs the logic required for getting proper inputs from the System.
void i_update(csys_Input i);

/// @descr Initializes and returns a System object
csys_System csys_init(csys_init_args in);
/// @descr Runs the logic required for updating the Window and Input of the System.
void csys_update(csys_System* sys);
/// @descr Returns true if the System has been marked for closing.
bool csys_close(csys_System* sys); 
/// @descr Terminates the System.
void csys_term(csys_System* sys);

