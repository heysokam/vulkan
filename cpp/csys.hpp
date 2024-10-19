//:____________________________________________________________________
//  Cendk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:____________________________________________________________________
/// Window+Input creation and management.  |
/// Currently only supports wgpu and vk.   |
//_________________________________________|
#pragma once
// External dependencies
#include "./cglfw.hpp"
// cendk dependencies
#include "./cstd.hpp"


//__________________________________________________________
// GLFW: Functionality extend
//______________________________________

namespace glfw {
namespace instance {
/// Requests all extensions required for creating a Vulkan Instance in this system.
vec<cstr> getExtensionsRequired(void);
} // namespace instance
} // namespace glfw


namespace csys {
//__________________________________________________________
// GLFW: Window Management
//______________________________________

/// Contains the window context and its properties.
struct Window {
  glfw::Window* ct    = nullptr;
  UVec2         size  = glm::uvec2(940, 560);
  str           title = "Cendk | Engine";
};

namespace w {  /// Window functionality
/// Function input arguments
namespace args {  // clang-format off
struct init {
  // Window config
  str title; u32 width; u32 height; bool resize;
  glfw::cb::resize resizeCB; glfw::cb::error error;  // General callbacks
  // Input callbacks
  glfw::cb::key key; glfw::cb::mousePos mousePos; glfw::cb::mouseBtn mouseBtn; glfw::cb::scroll mouseScroll;
  };  /// w::init( ... )
}  // clang-format on

//______________________________________
// External interface
//____________________________

/// Error callback for GLFW
void error(i32 code, const char* descr);
/// Resize callback for GLFW
void resize(glfw::Window* window, int width, int height);
/// Initializes and returns a window.
csys::Window init(args::init in);
/// Gets the current size of the given window, and stores it in its .size field.
void updateSize(csys::Window win);
/// Runs the logic required for rendering one frame with this window.
void update(csys::Window win);
/// Returns true if the window has been marked for closing.
bool close(csys::Window w);
/// Terminates the window.
void term(csys::Window w);
}  // namespace w


//__________________________________________________________
// GLFW: Input Management
//______________________________________

namespace i {
/// Update the inputs for this frame.
void update(void);
/// Keyboard input function for GLFW.
void key (glfw::Window* win, i32 key, i32 code, i32 action, i32 mods);
/// Mouse Position input Callback for GLFW
void mousePos (glfw::Window* win, double xpos, double ypos);
/// Mouse Button input Callback for GLFW
void mouseBtn (glfw::Window* win, int btn, int action, int mods);
/// Mouse Scroll input Callback for GLFW
void mouseScroll (glfw::Window* win, double xoff, double yoff);
}  // namespace i


//__________________________________________________________
// System Module Abstraction
//______________________________________

/// System Class Abstraction. Uses all internal defaults and functions.
class System {
public:
  System(str title, u32 width, u32 height, bool resize);
  void update(void);
  bool close(void){ return w::close(m->win); }
  ~System();
  csys::Window win;
private:
  System* m = this;
};
}; // namespace csys

