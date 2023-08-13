//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#include "./cvk.h"

#include <stdio.h>
int main(const int argc, const char *argv[]) {
  printf("hello world\n");
  opt_parse(argc, argv);
  cWindow w = w_init((w_init_args){
      .title = "Hello Window",
      .width = 960,
      .height = 540,
      .resize = false,
      .resizeCB = w_resize,
      .error = w_error,
      .key = i_key,
      .mousePos = NULL,
      .mouseBtn = NULL,
      .mouseScroll = NULL,
  });
  while (!w_close(w)) {
    w_update(w);
  }
  w_term(w);
  return 0;
}
