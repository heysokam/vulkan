//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#if !defined cdk_input
#include "./input.h"
#endif

void i_key(GLFWwindow* win, int key, int code, int action, int mods) {
  discard(win); discard(key); discard(code); discard(action); discard(mods);
  if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
    glfwSetWindowShouldClose(win, true);
  }
}

