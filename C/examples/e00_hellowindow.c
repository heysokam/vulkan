//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// Hello Window example                           |
// Creates a window with GLFW and keeps it open.  |
// It can be closed by pressing the Escape key.   |
//________________________________________________|
#include "../cvk.h"

#include <stdio.h>
int main(int const argc, char const* argv[]) {
  printf("hello world\n");
  opt_parse(argc, argv);
  cWindow w = w_init((w_init_args){ // clang-format off
    .title       = "c*vk | Hello Window",
    .width       = 960,
    .height      = 540,
    .resize      = false,
    .resizeCB    = w_resize,
    .error       = w_error,
    .key         = i_key,
    .mousePos    = NULL,
    .mouseBtn    = NULL,
    .mouseScroll = NULL,
  }); // clang-format on
  while (!w_close(w)) {
    w_update(w);
  }
  w_term(w);
  return 0;
}
