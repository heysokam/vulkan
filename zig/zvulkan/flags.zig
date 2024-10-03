//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const flags = @This();
// @deps std
const std = @import("std");
// @deps vulkan
const c = @import("../lib/vulkan.zig");
const vk = @import("./types.zig");

pub fn Flags (comptime T :type) type {
  comptime std.debug.assert(@sizeOf(T) == 4);
  return struct {
    pub const Int = vk.Flags;
    pub fn toInt     (v :T      ) Int  { return @bitCast(v); }
    pub fn fromInt   (v :Int    ) T    { return @bitCast(v); }
    pub fn with      (a :T, b :T) T    { return fromInt(toInt(a) | toInt(b)); }
    pub fn only      (a :T, b :T) T    { return fromInt(toInt(a) & toInt(b)); }
    pub fn without   (a :T, b :T) T    { return fromInt(toInt(a) & ~toInt(b)); }
    pub fn hasAllSet (a :T, b :T) bool { return (toInt(a) & toInt(b)) == toInt(b); }
    pub fn hasAnySet (a :T, b :T) bool { return (toInt(a) & toInt(b)) != 0; }
    pub fn isEmpty   (a :T      ) bool { return toInt(a) == 0; }
  };
}

pub const InstanceCreate = packed struct {
  enumeratePortability  :bool= false, // c.VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR,
  __reserved_bits_00_30 :u31=  0,
  pub usingnamespace Flags(@This());
};

