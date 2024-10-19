//:__________________________________________________________________
//  vk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
// @deps cdk
#include "cstd.hpp"
#include "csys.hpp"
#include "cvulkan.hpp"
// @deps Buildsystem SCU
#include "./cstd.cpp"
#include "./csys.cpp"


namespace cfg {
const str  label      = "vk+";
const u32  W          = 960;
const u32  H          = 540;
const bool resizable  = false;
const u32  appVers    = cvk::version::make(0, 0, 0);
const u32  engineVers = cvk::version::make(0, 0, 0);
}  // namespace cfg


//__________________________________________________________________
/// Entry Point
//________________________________________________
// using namespace cvk;
i32 main (i32 const argc, cstr argv[argc]) {
  echo(str("Hello ") + cfg::label);
  csys::System sys(cfg::label + " | Example", cfg::W, cfg::H, cfg::resizable);
  // Gpu gpu(cfg::label, cfg::appVers, cfg::engineVers, &sys.win);
  while (!sys.close()) {
    sys.update();
    // gpu.update();
  }
  return 0;
} //:: main

