//:__________________________________________________________________
//  vk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#define Cen_std
#include "./lib/cendk/std.hpp"
#define Cen_system
#include "./lib/cendk/system.hpp"
#define Cen_opts
#include "./lib/cendk/opts.hpp"
#include "./lib/cendk/lib/vulkan.hpp"

namespace cvk {
class Gpu {
public:
  Gpu();
  ~Gpu();

private:
  Gpu *m = this;
  // Components
  str           label    = "vk+";
  cvk::Instance instance = nullptr;
};
Gpu::Gpu() {discard(m,instance);}
Gpu::~Gpu() {}
} // namespace cvk


namespace cvk {
namespace args {
// clang-format off
struct init {
  str label;
  u32 appVersion; u32 engineVersion;
  };  /// r::init( ... )
// clang-format on
} // namespace args

// Version Generation
inline u32 makeVersion(const u32 major, const u32 minor, const u32 patch) { return VK_MAKE_VERSION(major,minor,patch); }
inline u32 apiVersion(const u32 major, const u32 minor, const u32 patch) { return VK_MAKE_API_VERSION(0,major,minor,patch); }
} // namespace cvk

int main(int argc, const char *argv[]) {
  opt::parse(argc, argv);
  echo(str("Hello World"));
  Sys sys("vk+ | Example", 960, 540, false);
  cvk::Gpu(gpu);
  while (!sys.close())
    sys.update();
  return 0;
}
