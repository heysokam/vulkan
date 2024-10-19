//:___________________________________________________________________
//  cdk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
#include "./csys.hpp"


//__________________________________________________________
// GLFW: Functionality extend
//______________________________________

namespace glfw {
namespace instance {
/// Returns a vector containing the names of all the Vulkan Extensions required
/// to create an instance
vec<cstr> getExtensionsRequired(void) {
  u32 extensionCount = 0;
  cstr* extensions = glfw::instanceGetExtensionsRequired(&extensionCount);
  vec<cstr> result;
  for (u32 it = 0; it < extensionCount; it++) {
    result.push_back(extensions[it]);
  }
  return result;
}
} // namespace instance
} // namespace glfw


//__________________________________________________________
// GLFW: Window Management
//______________________________________
namespace csys {

namespace w {
//____________________________
void updateSize(csys::Window win) { glfw::window::size(win.ct, (int*)&win.size.x, (int*)&win.size.y); }
//____________________________
void update(csys::Window win) { updateSize(win); }
//____________________________
void resize(glfw::Window* window, int width, int height) { discard(window, width, height); }
//____________________________
void error(i32 code, const char* descr) { err(code, descr); }

//____________________________
csys::Window init(args::init in) {
  if (not glfw::init()) throw std::runtime_error("Failed to Initialize GLFW");
  glfw::cb::setError(in.error);
  glfw::hint(glfw::ClientApi, glfw::NoApi);
  glfw::hint(glfw::Resizable, in.resize);
  // Continue
  csys::Window result = {
    .ct    = glfw::window::create((int)in.width, (int)in.height, in.title.data(), NULL, NULL),
    .size  = glm::uvec2(in.width, in.height),
    .title = in.title,
  };
  if (not result.ct) {
    glfw::term();
    throw std::runtime_error("Failed to create the GLFW window");
  }
  glfw::cb::setResize(result.ct, in.resizeCB);
  // TODO: Move to i::init()
  glfw::cb::setKey(result.ct, in.key);
  glfw::cb::setMousePos(result.ct, in.mousePos);
  glfw::cb::setMouseBtn(result.ct, in.mouseBtn);
  glfw::cb::setScroll(result.ct, in.mouseScroll);
  return result;
}

//______________________________________
bool close(csys::Window w) { return glfw::window::close(w.ct); }
//____________________________
void term(csys::Window w) {
  glfw::window::destroy(w.ct);
  glfw::term();
}
}  // namespace w


//__________________________________________________________
// GLFW: Input Management
//______________________________________

namespace i { // Input system

namespace man {  // Input Manager
// TODO
}  // namespace man

void update(void) { glfw::events::poll(); }

// Callbacks
void key(glfw::Window* win, i32 key, i32 code, i32 action, i32 mods) {
  discard(code, mods);
  if (key == glfw::key::Escape && action == glfw::action::Press) glfw::window::setClose(win, (int)true);
}
void mousePos    (glfw::Window* win, double xpos, double ypos) { discard(win, xpos, ypos); }
void mouseBtn    (glfw::Window* win, int btn, int action, int mods) { discard(win, btn, action, mods); }
void mouseScroll (glfw::Window* win, double xoff, double yoff) { discard(win, xoff, yoff); }
}  // namespace i


//__________________________________________________________
// System Module Abstraction
//______________________________________
System::System (str title, u32 width, u32 height, bool resize) {
  m->win = w::init({
    .title       = title,
    .width       = width,
    .height      = height,
    .resize      = resize,
    .resizeCB    = w::resize,
    .error       = w::error,
    .key         = i::key,
    .mousePos    = i::mousePos,
    .mouseBtn    = i::mouseBtn,
    .mouseScroll = i::mouseScroll,
  });
}

System::~System (void) {
  w::term(m->win);
}
void System::update (void) {
  i::update();
}

}; //:: csys

