//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Vulkan Result Management
//_________________________________________|
pub const result = @This();
// @deps vulkan
const c = @import("../lib/vulkan.zig");
const String = @import("./types.zig").String;

const T = c.VkResult;
pub const Result = result.T;

pub fn ok (R :result.T) !void {
  const code :result.Code= @enumFromInt(R);
  switch (code) {
    result.Code.ok                                          => {},
    result.Code.notReady                                    => return error.NotReady,
    result.Code.timeout                                     => return error.Timeout,
    result.Code.eventSet                                    => return error.EventSet,
    result.Code.eventReset                                  => return error.EventReset,
    result.Code.incomplete                                  => return error.Incomplete,
    result.Code.errorOutOfHostMemory                        => return error.ErrorOutOfHostMemory,
    result.Code.errorOutOfDeviceMemory                      => return error.ErrorOutOfDeviceMemory,
    result.Code.errorInitializationFailed                   => return error.ErrorInitializationFailed,
    result.Code.errorDeviceLost                             => return error.ErrorDeviceLost,
    result.Code.errorMemoryMapFailed                        => return error.ErrorMemoryMapFailed,
    result.Code.errorLayerNotPresent                        => return error.ErrorLayerNotPresent,
    result.Code.errorExtensionNotPresent                    => return error.ErrorExtensionNotPresent,
    result.Code.errorFeatureNotPresent                      => return error.ErrorFeatureNotPresent,
    result.Code.errorIncompatibleDriver                     => return error.ErrorIncompatibleDriver,
    result.Code.errorTooManyObjects                         => return error.ErrorTooManyObjects,
    result.Code.errorFormatNotSupported                     => return error.ErrorFormatNotSupported,
    result.Code.errorFragmentedPool                         => return error.ErrorFragmentedPool,
    result.Code.errorUnknown                                => return error.ErrorUnknown,
    result.Code.errorOutOfPoolMemory                        => return error.ErrorOutOfPoolMemory,
    result.Code.errorInvalidExternalHandle                  => return error.ErrorInvalidExternalHandle,
    result.Code.errorFragmentation                          => return error.ErrorFragmentation,
    result.Code.errorInvalidOpaqueCaptureAddress            => return error.ErrorInvalidOpaqueCaptureAddress,
    result.Code.pipelineCompileRequired                     => return error.PipelineCompileRequired,
    result.Code.errorSurfaceLostKhr                         => return error.ErrorSurfaceLostKhr,
    result.Code.errorNativeWindowInUseKhr                   => return error.ErrorNativeWindowInUseKhr,
    result.Code.suboptimalKhr                               => return error.SuboptimalKhr,
    result.Code.errorOutOfDateKhr                           => return error.ErrorOutOfDateKhr,
    result.Code.errorIncompatibleDisplayKhr                 => return error.ErrorIncompatibleDisplayKhr,
    result.Code.errorValidationFailedExt                    => return error.ErrorValidationFailedExt,
    result.Code.errorInvalidShaderNv                        => return error.ErrorInvalidShaderNv,
    result.Code.errorImageUsageNotSupportedKhr              => return error.ErrorImageUsageNotSupportedKhr,
    result.Code.errorVideoPictureLayoutNotSupportedKhr      => return error.ErrorVideoPictureLayoutNotSupportedKhr,
    result.Code.errorVideoProfileOperationNotSupportedKhr   => return error.ErrorVideoProfileOperationNotSupportedKhr,
    result.Code.errorVideoProfileFormatNotSupportedKhr      => return error.ErrorVideoProfileFormatNotSupportedKhr,
    result.Code.errorVideoProfileCodecNotSupportedKhr       => return error.ErrorVideoProfileCodecNotSupportedKhr,
    result.Code.errorVideoStdVersionNotSupportedKhr         => return error.ErrorVideoStdVersionNotSupportedKhr,
    result.Code.errorInvalidDrmFormatModifierPlaneLayoutExt => return error.ErrorInvalidDrmFormatModifierPlaneLayoutExt,
    result.Code.errorNotPermittedKhr                        => return error.ErrorNotPermittedKhr,
    result.Code.errorFullScreenExclusiveModeLostExt         => return error.ErrorFullScreenExclusiveModeLostExt,
    result.Code.threadIdleKhr                               => return error.ThreadIdleKhr,
    result.Code.threadDoneKhr                               => return error.ThreadDoneKhr,
    result.Code.operationDeferredKhr                        => return error.OperationDeferredKhr,
    result.Code.operationNotDeferredKhr                     => return error.OperationNotDeferredKhr,
    result.Code.errorInvalidVideoStdParametersKhr           => return error.ErrorInvalidVideoStdParametersKhr,
    result.Code.errorCompressionExhaustedExt                => return error.ErrorCompressionExhaustedExt,
    result.Code.incompatibleShaderBinaryExt                 => return error.IncompatibleShaderBinaryExt,
    result.Code.pipelineBinaryMissingKhr                    => return error.PipelineBinaryMissingKhr,
    result.Code.errorNotEnoughSpaceKhr                      => return error.ErrorNotEnoughSpaceKhr,
    // result.Code.errorOutOfPoolMemoryKhr                     => return error.ErrorOutOfPoolMemoryKhr,
    // result.Code.errorInvalidExternalHandleKhr               => return error.ErrorInvalidExternalHandleKhr,
    // result.Code.errorFragmentationExt                       => return error.ErrorFragmentationExt,
    // result.Code.errorNotPermittedExt                        => return error.ErrorNotPermittedExt,
    // result.Code.errorInvalidDeviceAddressExt                => return error.ErrorInvalidDeviceAddressExt,
    // result.Code.errorInvalidOpaqueCaptureAddressKhr         => return error.ErrorInvalidOpaqueCaptureAddressKhr,
    // result.Code.pipelineCompileRequiredExt                  => return error.PipelineCompileRequiredExt,
    // result.Code.errorPipelineCompileRequiredExt             => return error.ErrorPipelineCompileRequiredExt,
    // result.Code.errorIncompatibleShaderBinaryExt            => return error.ErrorIncompatibleShaderBinaryExt,
    else => return error.Unknown,
  }
}

pub const Code = enum(i32) {
  ok                                            = 0,
  notReady                                      = 1,
  timeout                                       = 2,
  eventSet                                      = 3,
  eventReset                                    = 4,
  incomplete                                    = 5,
  errorOutOfHostMemory                          = -1,
  errorOutOfDeviceMemory                        = -2,
  errorInitializationFailed                     = -3,
  errorDeviceLost                               = -4,
  errorMemoryMapFailed                          = -5,
  errorLayerNotPresent                          = -6,
  errorExtensionNotPresent                      = -7,
  errorFeatureNotPresent                        = -8,
  errorIncompatibleDriver                       = -9,
  errorTooManyObjects                           = -10,
  errorFormatNotSupported                       = -11,
  errorFragmentedPool                           = -12,
  errorUnknown                                  = -13,
  errorOutOfPoolMemory                          = -1000069000,
  errorInvalidExternalHandle                    = -1000072003,
  errorFragmentation                            = -1000161000,
  errorInvalidOpaqueCaptureAddress              = -1000257000,
  pipelineCompileRequired                       = 1000297000,
  errorSurfaceLostKhr                           = -1000000000,
  errorNativeWindowInUseKhr                     = -1000000001,
  suboptimalKhr                                 = 1000001003,
  errorOutOfDateKhr                             = -1000001004,
  errorIncompatibleDisplayKhr                   = -1000003001,
  errorValidationFailedExt                      = -1000011001,
  errorInvalidShaderNv                          = -1000012000,
  errorImageUsageNotSupportedKhr                = -1000023000,
  errorVideoPictureLayoutNotSupportedKhr        = -1000023001,
  errorVideoProfileOperationNotSupportedKhr     = -1000023002,
  errorVideoProfileFormatNotSupportedKhr        = -1000023003,
  errorVideoProfileCodecNotSupportedKhr         = -1000023004,
  errorVideoStdVersionNotSupportedKhr           = -1000023005,
  errorInvalidDrmFormatModifierPlaneLayoutExt   = -1000158000,
  errorNotPermittedKhr                          = -1000174001,
  errorFullScreenExclusiveModeLostExt           = -1000255000,
  threadIdleKhr                                 = 1000268000,
  threadDoneKhr                                 = 1000268001,
  operationDeferredKhr                          = 1000268002,
  operationNotDeferredKhr                       = 1000268003,
  errorInvalidVideoStdParametersKhr             = -1000299000,
  errorCompressionExhaustedExt                  = -1000338000,
  incompatibleShaderBinaryExt                   = 1000482000,
  pipelineBinaryMissingKhr                      = 1000483000,
  errorNotEnoughSpaceKhr                        = -1000483000,
  _,
  pub const errorOutOfPoolMemoryKhr             = Code.errorOutOfPoolMemory;
  pub const errorInvalidExternalHandleKhr       = Code.errorInvalidExternalHandle;
  pub const errorFragmentationExt               = Code.errorFragmentation;
  pub const errorNotPermittedExt                = Code.errorNotPermittedKhr;
  pub const errorInvalidDeviceAddressExt        = Code.errorInvalidOpaqueCaptureAddress;
  pub const errorInvalidOpaqueCaptureAddressKhr = Code.errorInvalidOpaqueCaptureAddress;
  pub const pipelineCompileRequiredExt          = Code.pipelineCompileRequired;
  pub const errorPipelineCompileRequiredExt     = Code.pipelineCompileRequired;
  pub const errorIncompatibleShaderBinaryExt    = Code.incompatibleShaderBinaryExt;
};
