//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./csys.h"
#include "cstd.h"

//__________________________________________________________
// Window
//______________________________________

csys_Window w_init(w_init_args in, csys_api api);

void w_error(i32 code, const char* descr) {
  discard(code);
  discard(descr);
}

void w_resize(GLFWwindow* window, int W, int H) {
  discard(window);
  discard(W);
  discard(H);
}

static void w_init_NoAPI(w_init_args in) {
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  glfwWindowHint(GLFW_RESIZABLE, in.resize);
}

static void w_init_OpenGL(w_init_args in) {
  discard(in);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 6);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
}

csys_Window w_init(w_init_args in, csys_api api) {
  switch (api) {
    case csys_api_opengl : w_init_OpenGL(in);break;
    case csys_api_none   : w_init_NoAPI(in); break;
  }
  csys_Window result = {
    .ct     = glfwCreateWindow((int)in.width, (int)in.height, in.title, NULL, NULL),
    .width  = in.width,
    .height = in.height,
    .title  = in.title,
  };
  if (api == csys_api_opengl) glfwMakeContextCurrent(result.ct);
  glfwSetFramebufferSizeCallback(result.ct, in.resizeCB);
  return result;
}

void w_updateSize(csys_Window win) { discard(win); }
void w_update(csys_Window win, csys_api api) { discard(win); discard(api); }
bool w_close(csys_Window w) { return glfwWindowShouldClose(w.ct); }
void w_term(csys_Window w) { glfwDestroyWindow(w.ct); }


//__________________________________________________________
// Input
//______________________________________

void i_key(GLFWwindow* win, int key, int code, int action, int mods) {  // clang-format off
  discard(win); discard(key); discard(code); discard(action); discard(mods);
  if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
    glfwSetWindowShouldClose(win, true);
  }
}  // clang-format on

csys_Input i_init(csys_Window win, i_init_args in) {
  glfwSetKeyCallback(win.ct, in.key);
  glfwSetCursorPosCallback(win.ct, in.mousePos);
  glfwSetMouseButtonCallback(win.ct, in.mouseBtn);
  glfwSetScrollCallback(win.ct, in.mouseScroll);
  return cdk_handle_new();
}

void i_update(csys_Input i) {
  discard(i);
  glfwPollEvents();
}


//__________________________________________________________
// System
//______________________________________

csys_System csys_init(csys_init_args in) {
  glfwInit();
  csys_System result;
  result.win = w_init(in.win, in.api);
  result.inp = i_init(result.win, in.inp);
  return result;
}

void csys_update(csys_System* sys) {
  i_update(sys->inp);
  w_update(sys->win, sys->api);
}

bool csys_close(csys_System* sys) { return w_close(sys->win); }

void csys_term(csys_System* sys) {
  w_term(sys->win);
  glfwTerminate();
}


