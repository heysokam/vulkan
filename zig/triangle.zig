//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("./zstd.zig");
const zsys = @import("./zsys.zig");


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
const shd = struct {
  const vert align(@alignOf(u32)) = @embedFile("shd_vert").*;
  const frag align(@alignOf(u32)) = @embedFile("shd_frag").*;
};
const appName = "Zig | Vulkan-All-the-Things | Triangle";
var size      = zgpu.Size{.width= 960, .height= 540};

//______________________________________
// @section Entry Point
//____________________________
pub fn main () !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = zgpu.Allocator.create(arena.allocator());

  try zstd.echo("Hello z*gpu | Triangle");
  try zstd.echo(appName);
  var sys = try zsys.init(size.width, size.height, appName);
  var gpu = try zgpu.init(.{
    .appName    = appName,
    .appVers    = zgpu.version.new(0, 0, 1),
    .engineName = "Hello z*gpu | Triangle Engine",
    .engineVers = zgpu.version.new(0, 0, 1),
    }, A);
  while (!sys.close()) {
    sys.update();
    gpu.update();
    }
  gpu.term();
  sys.term();
} //:: _main



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pub const zvk = struct {
  const vk = @import("./lib/vulkan.zig");

  //______________________________________
  // @section General Type Aliases
  //____________________________
  pub const String = vk.String;
  pub const Size   = vk.Size;
  pub const SpirV  = vk.SpirV;
  pub const version = vk.version;
  pub const Version = vk.Version;

  //______________________________________
  // @section Allocator
  //____________________________
  pub const Allocator = struct {
    zig  :std.mem.Allocator,
    vk   :?*const vk.Allocator,

    pub fn create (A :std.mem.Allocator) Allocator {
      return Allocator{
       .zig = A,
       .vk  = null  // @maybe Allocator library ?
        };
    } //:: zvk.Allocator.create
  }; //:: zvk.Allocator

  //______________________________________
  // @section Configuration and Defaults
  //____________________________
  pub const cfg = struct {
    // pub const features = struct {
    //   /// List of 'apis' to construct base, instance and device wrappers for vulkan-zig
    //   pub const list :[]const vk.ApiInfo = &.{
    //     .{  // Add invidiual functions by manually creating an 'api'
    //       .base_commands     = .{ .createInstance = true, },
    //       .instance_commands = .{ .createDevice   = true, },
    //       },
    //     // Add entire feature sets or extensions
    //     vk.features.version_1_0,
    //     vk.extensions.khr_surface,
    //     vk.extensions.khr_swapchain,
    //   }; //:: zvk.features.list
    // }; //:: zvk.features

    pub const default = struct {
      pub const version    = zvk.version.api.v1_0;
      pub const appName    = "zvk.Application";
      pub const appVers    = zvk.version.new(0, 0, 0);
      pub const engineName = "zvk.Engine";
      pub const engineVers = zvk.version.new(0, 0, 0);
    }; //:: zvk.cfg.default
  }; //:: zvk.cfg

  //______________________________________
  // @section Application
  //____________________________
  pub const App = struct {
    pub const Cfg = vk.App.Cfg;
    pub fn defaults (args :struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers,
      }) zvk.App.Cfg {
      return zvk.App.Cfg{
        .p_application_name  = args.appName,
        .application_version = args.appVers,
        .p_engine_name       = args.engineName,
        .engine_version      = args.engineVers,
        .api_version         = zvk.cfg.default.version,
        }; // << VkApplicationInfo{ ... }
    } //:: zvk.App.defaults
  }; //:: zvk.App

  //______________________________________
  // @section Instance
  //____________________________
  pub const Instance = struct {
    ct   :vk.instance.T,
    cfg  :vk.instance.Cfg,
  }; //:: zvk.Instance
}; //:: zvk


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pub const zgpu = struct {
  //______________________________________
  // @section zvk Forward Exports
  //____________________________
  pub const Allocator = zvk.Allocator;
  pub const String    = zvk.String;
  pub const Size      = zvk.Size;
  pub const SpirV     = zvk.SpirV;
  pub const version   = zvk.version;
  pub const Version   = zvk.Version;

  //______________________________________
  // @section Configuration
  //____________________________
  pub const cfg = struct {
    pub const default = struct {
      pub const appName    = "z*gpu | Application";
      pub const appVers    = zgpu.version.new(0, 0, 0);
      pub const engineName = "z*gpu | Engine";
      pub const engineVers = zgpu.version.new(0, 0, 0);
    }; //:: cfg.default
  }; //:: cfg

  //______________________________________
  // @section Core Logic
  //____________________________
  pub const Gpu = struct {
    A        :zvk.Allocator,
    instance :zvk.Instance,
    pub fn update (gpu :*Gpu) void {_=gpu;}
    pub fn term   (gpu :*Gpu) void {_=gpu;}

    pub fn init (_:struct {
        appName    : zvk.String  = zgpu.cfg.default.appName,
        appVers    : zvk.Version = zgpu.cfg.default.appVers,
        engineName : zvk.String  = zgpu.cfg.default.engineName,
        engineVers : zvk.Version = zgpu.cfg.default.engineVers, },
        A          : zvk.Allocator,
      ) !zgpu.Gpu {
      const result = Gpu{.A= A, .instance= undefined};
      return result;
    } //:: Gpu.init
  }; //:: Gpu
  pub const init = zgpu.Gpu.init;
}; //:: zgpu




//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

