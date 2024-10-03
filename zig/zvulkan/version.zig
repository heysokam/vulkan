//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Version Tools
//_________________________________________|
pub const version = @This();
// @deps vulkan
const c = @import("../lib/vulkan.zig");

pub const T     = u32;
pub const Major = u7;
pub const Minor = u10;
pub const Patch = u12;

pub const api = struct {
  pub const v1_0  = c.VK_API_VERSION_1_0;
  pub const v1_1  = c.VK_API_VERSION_1_1;
  pub const v1_2  = c.VK_API_VERSION_1_2;
  pub const v1_3  = c.VK_API_VERSION_1_3;
}; //:: vk.version.api

pub fn new (
  M : version.Major,
  m : version.Minor,
  p : version.Patch,
) Version {
  return c.VK_MAKE_API_VERSION(0, M,m,p);
} //:: zvk.version.new

pub const Version = version.T;

