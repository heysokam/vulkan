//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Vulkan Result Management
//_________________________________________|
pub const result = @This();
// @deps vulkan
const c = @import("../lib/vulkan.zig");

const T = c.VkResult;
pub const Result = result.T;

