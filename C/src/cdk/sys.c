//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#if !defined cdk_system
#  include "./sys.h"
#endif

//__________________________________________________________
// Window
//______________________________________

cWindow w_init(w_init_args in);

void w_error(i32 code, const char* descr) {
  discard(code);
  discard(descr);
}

void w_resize(GLFWwindow* window, int W, int H) {
  discard(window);
  discard(W);
  discard(H);
}

cWindow w_init(w_init_args in) {
  glfwInit();
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  glfwWindowHint(GLFW_RESIZABLE, in.resize);
  cWindow result = {
    .ct     = glfwCreateWindow((int)in.width, (int)in.height, in.title, NULL, NULL),
    .width  = in.width,
    .height = in.height,
    .title  = in.title,
  };
  glfwSetFramebufferSizeCallback(result.ct, in.resizeCB);
  return result;
}

void w_updateSize(cWindow win) { discard(win); }
void w_update(cWindow win) { discard(win); }
bool w_close(cWindow w) { return glfwWindowShouldClose(w.ct); }
void w_term(cWindow w) { glfwDestroyWindow(w.ct); }


//__________________________________________________________
// Input
//______________________________________

void i_key(GLFWwindow* win, int key, int code, int action, int mods) {  // clang-format off
  discard(win); discard(key); discard(code); discard(action); discard(mods);
  if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
    glfwSetWindowShouldClose(win, true);
  }
}  // clang-format on

cInput i_init(cWindow win, i_init_args in) {
  glfwSetKeyCallback(win.ct, in.key);
  glfwSetCursorPosCallback(win.ct, in.mousePos);
  glfwSetMouseButtonCallback(win.ct, in.mouseBtn);
  glfwSetScrollCallback(win.ct, in.mouseScroll);
  return newHandle();
}

void i_update(cInput i) {
  discard(i);
  glfwPollEvents();
}


//__________________________________________________________
// System
//______________________________________

System csys_init(csys_init_args in) {
  System result;
  result.win    = w_init(in.win);
  result.inp    = i_init(result.win, in.inp);
  return result;
}

void csys_update(System* sys) {
  i_update(sys->inp);
  w_update(sys->win);
}

bool csys_close(System* sys) { return w_close(sys->win); }

void csys_term(System* sys) {
  w_term(sys->win);
  glfwTerminate();
}
