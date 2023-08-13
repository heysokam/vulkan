//:___________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
//:___________________________________________________
#if !defined cvk_window
#include "./window.h"
#endif

cWindow w_init(w_init_args in);

/// Error callback for GLFW
void w_error(i32 code, const char *descr) {
  discard(code);
  discard(descr);
}

void w_resize(GLFWwindow *window, int W, int H) {
  discard(window);
  discard(W);
  discard(H);
}
/// Initializes and returns a window.
cWindow w_init(w_init_args in) {
  glfwInit();
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  glfwWindowHint(GLFW_RESIZABLE, in.resize);
  cWindow result = {
      .ct =
          glfwCreateWindow((int)in.width, (int)in.height, in.title, NULL, NULL),
      .width = in.width,
      .height = in.height,
      .title = in.title,
  };
  glfwSetFramebufferSizeCallback(result.ct, in.resizeCB);
  glfwSetKeyCallback(result.ct, in.key);
  glfwSetCursorPosCallback(result.ct, in.mousePos);
  glfwSetMouseButtonCallback(result.ct, in.mouseBtn);
  glfwSetScrollCallback(result.ct, in.mouseScroll);
  return result;
}

/// Gets the current size of the given window, and stores it in its .size field.
void w_updateSize(cWindow win) { discard(win); }

void w_update(cWindow win) {
  discard(win);
  glfwPollEvents();
}

bool w_close(cWindow w) { return glfwWindowShouldClose(w.ct); }

void w_term(cWindow w) {
  glfwDestroyWindow(w.ct);
  glfwTerminate();
}
