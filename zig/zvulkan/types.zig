//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview General Vulkan Type Aliases
//____________________________________________|
// @deps std
const std = @import("std");
// @deps vulkan
const c = @import("../lib/vulkan.zig");

pub const String      = [:0]const u8;
pub const StringList  = std.ArrayList(String);
pub const CString     = [*:0]const u8;            // pub const String = [*:0]const u8;
pub const CStringList = std.ArrayList(CString);   // pub const String = [*c][*c]const u8;
pub const SpirV       = CString;                  // vk.String; // []const u8; // [*:0]const u8;
pub const Allocator   = c.VkAllocationCallbacks;
pub const Size        = c.VkExtent2D;
pub const Vol         = c.VkExtent3D;
pub const Flags       = c.VkFlags;

