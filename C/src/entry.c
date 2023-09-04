//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// Hello Vulkan Context                                   |
// Creates a window with GLFW,                            |
// and creates the most minimal vulkan context possible.  |
//________________________________________________________|
#include "./cvk.h"

#include <stdio.h>
int main(const int argc, const char* argv[]) {
  #if debug
  printf("hello world with -DDEBUG\n");
  #endif
  opt_parse(argc, argv);
  System sys = csys_init((csys_init_args) {
    // clang-format off
    .win = (w_init_args){
      .title       = "c*vk | Hello Vulkan",
      .width       = 960,
      .height      = 540,
      .resize      = false,
      .resizeCB    = w_resize,
      .error       = w_error,
      }, // << window
    .inp = (i_init_args){
      .key         = i_key,
      .mousePos    = NULL,
      .mouseBtn    = NULL,
      .mouseScroll = NULL,
      }, // << input
  });  // clang-format on
  Vulkan gpu = cvk_init((cvk_init_args) {
    .appName    = "c*vk | Application",
    .appVers    = cdk_makeVersion(0, 0, 0),
    .engineName = "c*vk | Engine",
    .engineVers = cdk_makeVersion(0, 0, 0),
  });
  while (!csys_close(&sys)) {
    csys_update(&sys);
    cvk_update(&gpu);
  }
  cvk_term(&gpu);
  csys_term(&sys);
  return 0;
}
