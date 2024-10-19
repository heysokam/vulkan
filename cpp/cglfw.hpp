//:____________________________________________________________________
//  Cendk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:____________________________________________________________________
#pragma once
#  define GLFW_INCLUDE_VULKAN
#if defined Cen_vk
#endif  // Cen_vk
#include <GLFW/glfw3.h>
#include "./alias.hpp"


namespace glfw {
// Types
using Window  = GLFWwindow;
using Monitor = GLFWmonitor;

// IDs
alias(ClientApi, GLFW_CLIENT_API);
alias(NoApi, GLFW_NO_API);
alias(Resizable, GLFW_RESIZABLE);

// Functions
alias(init, glfwInit);
alias(hint, glfwWindowHint);
alias(term, glfwTerminate);
alias(getError, glfwGetError);

namespace cb {  /// GLFW Callbacks
using error    = GLFWerrorfun;
using resize   = GLFWframebuffersizefun;
using key      = GLFWkeyfun;
using mousePos = GLFWcursorposfun;
using mouseBtn = GLFWmousebuttonfun;
using scroll   = GLFWscrollfun;
alias(setError, glfwSetErrorCallback);
alias(setResize, glfwSetFramebufferSizeCallback);
alias(setKey, glfwSetKeyCallback);
alias(setMousePos, glfwSetCursorPosCallback);
alias(setMouseBtn, glfwSetMouseButtonCallback);
alias(setScroll, glfwSetScrollCallback);
}  // namespace cb

namespace window {
alias(size, glfwGetWindowSize);
alias(create, glfwCreateWindow);
alias(setClose, glfwSetWindowShouldClose);
alias(close, glfwWindowShouldClose);
alias(destroy, glfwDestroyWindow);
}  // namespace window

namespace key {
alias(Escape, GLFW_KEY_ESCAPE);
}  // namespace key

namespace action {
alias(Press, GLFW_PRESS);
alias(Release, GLFW_RELEASE);
alias(Repeat, GLFW_REPEAT);
}  // namespace action
namespace events {
alias(poll, glfwPollEvents);
}  // namespace events


//______________________________________
// Vulkan Specifics
alias(instanceGetExtensionsRequired, glfwGetRequiredInstanceExtensions);
namespace window {
alias(createSurfaceVk, glfwCreateWindowSurface);
}  // namespace vk.window
//______________________________________

}  // namespace glfw
