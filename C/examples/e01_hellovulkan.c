//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// Hello Vulkan Context                                   |
// Creates a window with GLFW,                            |
// and creates the most minimal vulkan context possible.  |
//________________________________________________________|
#include "../src/cvk.h"

#include <stdio.h>
int main(const int argc, const char *argv[]) {
  printf("hello world\n");
  opt_parse(argc, argv);
  Vulkan vk = cvk_init((cvk_init_args){ // clang-format off
    .title       = "c*vk | Hello Vulkan",
    .width       = 960,
    .height      = 540,
    .resize      = false,
    .resizeCB    = w_resize,
    .error       = w_error,
    .key         = i_key,
    .mousePos    = NULL,
    .mouseBtn    = NULL,
    .mouseScroll = NULL,
    .appName     = "c*vk | Application",
    .appVers     = cdk_makeVersion(0, 0, 0),
    .engineName  = "c*vk | Engine",
    .engineVers  = cdk_makeVersion(0, 0, 0),
  }); // clang-format on
  while (!cvk_close(&vk)) {
    cvk_update(&vk);
  }
  cvk_term(&vk);
  return 0;
}
