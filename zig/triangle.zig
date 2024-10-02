//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("./zstd.zig");
const zsys = @import("./zsys.zig");

pub const zvk = struct {
  pub const String  = [*:0]const u8;

  pub const version   = struct {
    const vk = @import("./lib/vulkan.zig");
    pub const api     = struct {
      pub const v1_0  = vk.API_VERSION_1_0;
      pub const v1_1  = vk.API_VERSION_1_1;
      pub const v1_2  = vk.API_VERSION_1_2;
      pub const v1_3  = vk.API_VERSION_1_3;
    }; //:: zvk.version.api

    pub const Version = u32;
    pub const Major   = u7;
    pub const Minor   = u10;
    pub const Patch   = u12;

    pub fn new (
        M : zvk.version.Major,
        m : zvk.version.Minor,
        p : zvk.version.Patch,
      ) zvk.version.Version {
      return vk.makeApiVersion(0, M,m,p);
    } //:: zvk.version.new
  }; //:: zvk.version
  pub const Version = zvk.version.Version;

  pub const Allocator = struct {
    const vulkan = @import("./lib/vulkan.zig");

    zig  :std.mem.Allocator,
    vk   :?*const vulkan.AllocationCallbacks,

    pub fn create (A :std.mem.Allocator) Allocator {
      return Allocator{
       .zig = A,
       .vk  = null  // @maybe Allocator library ?
        };
    } //:: zvk.Allocator.create
  }; //:: zvk.Allocator

  pub const cfg = struct {
    pub const features = struct {
      const vk = @import("./lib/vulkan.zig");
      /// List of 'apis' to construct base, instance and device wrappers for vulkan-zig
      pub const list :[]const vk.ApiInfo = &.{
        .{  // Add invidiual functions by manually creating an 'api'
          .base_commands     = .{ .createInstance = true, },
          .instance_commands = .{ .createDevice   = true, },
          },
        // Add entire feature sets or extensions
        vk.features.version_1_0,
        vk.extensions.khr_surface,
        vk.extensions.khr_swapchain,
      }; //:: zvk.features.list
    }; //:: zvk.features

    pub const default = struct {
      pub const version    = zvk.version.api.v1_0;
      pub const appName    = "zvk.Application";
      pub const appVers    = zvk.version.new(0, 0, 0);
      pub const engineName = "zvk.Engine";
      pub const engineVers = zvk.version.new(0, 0, 0);
    }; //:: zvk.cfg.default
  }; //:: zvk.cfg

  pub const app = struct {
    const vk = @import("./lib/vulkan.zig");
    //______________________________________
    // @section Application
    //____________________________
    pub const Cfg = vk.ApplicationInfo;
    pub fn defaults (args :struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers,
      }) app.Cfg {
      return app.Cfg{
        .p_application_name  = args.appName,
        .application_version = args.appVers,
        .p_engine_name       = args.engineName,
        .engine_version      = args.engineVers,
        .api_version         = zvk.cfg.default.version,
        }; // << VkApplicationInfo{ ... }
    } //:: zvk.app.defaults
  }; //:: zvk.app
}; //:: zvk

pub const zgpu = struct {
  //______________________________________
  // @section zvk Forward Exports
  //____________________________
  pub const Allocator = zvk.Allocator;
  pub const version   = zvk.version;

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
    // loader   :zvk.Loader,
    // instance :zvk.Instance,
    pub fn update (gpu :*Gpu) void {_=gpu;}
    pub fn term   (gpu :*Gpu) void {_=gpu;}

    pub fn init (_:struct {
        appName    : zvk.String  = zgpu.cfg.default.appName,
        appVers    : zvk.Version = zgpu.cfg.default.appVers,
        engineName : zvk.String  = zgpu.cfg.default.engineName,
        engineVers : zvk.Version = zgpu.cfg.default.engineVers, },
        A          : zvk.Allocator,
      ) !zgpu.Gpu {
      const result = Gpu{.A= A, .loader= undefined, .instance= undefined};
      return result;
    } //:: Gpu.init
  }; //:: Gpu
  pub const init = zgpu.Gpu.init;
}; //:: zgpu

pub fn _main () !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = zgpu.Allocator.create(arena.allocator());

  try zstd.echo("Hello z*gpu | Triangle");
  var sys = zsys.init(960,540,"Hello z*gpu | Triangle");
  var gpu = try zgpu.init(.{
    .appName    = "Hello z*gpu | Triangle",
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


pub fn main () !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  // const A = zgpu.Allocator.create(arena.allocator());
  try zstd.echo("Hello zig.vulkan.Triangle");

}
