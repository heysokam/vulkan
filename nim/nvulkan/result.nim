#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h".}

type Result *{.importc:"VkResult", vulkan, pure, size:sizeof(int32).}= enum
  err_notEnoughSpace                        = -1000483000 , # VK_ERROR_NOT_ENOUGH_SPACE_KHR                         = -1000483000,
  err_compressionExhausted                  = -1000338000 , # VK_ERROR_COMPRESSION_EXHAUSTED_EXT                    = -1000338000,
  err_invalid_videoSTDParameters            = -1000299000 , # VK_ERROR_INVALID_VIDEO_STD_PARAMETERS_KHR             = -1000299000,
  err_invalid_opaqueCaptureAddr             = -1000257000 , # VK_ERROR_INVALID_OPAQUE_CAPTURE_ADDRESS               = -1000257000,
  err_fullScreenExclusiveModeLost           = -1000255000 , # VK_ERROR_FULL_SCREEN_EXCLUSIVE_MODE_LOST_EXT          = -1000255000,
  err_notPermitted                          = -1000174001 , # VK_ERROR_NOT_PERMITTED_KHR                            = -1000174001,
  err_fragmentation                         = -1000161000 , # VK_ERROR_FRAGMENTATION                                = -1000161000,
  err_invalid_DRMFormatModifier_planeLayout = -1000158000 , # VK_ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT = -1000158000,
  err_invalid_externalHandle                = -1000072003 , # VK_ERROR_INVALID_EXTERNAL_HANDLE                      = -1000072003,
  err_video_notSupported_STDVersion         = -1000023005 , # VK_ERROR_VIDEO_STD_VERSION_NOT_SUPPORTED_KHR          = -1000023005,
  err_video_notSupported_codec              = -1000023004 , # VK_ERROR_VIDEO_PROFILE_CODEC_NOT_SUPPORTED_KHR        = -1000023004,
  err_video_notSupported_format             = -1000023003 , # VK_ERROR_VIDEO_PROFILE_FORMAT_NOT_SUPPORTED_KHR       = -1000023003,
  err_video_notSupported_profileOperation   = -1000023002 , # VK_ERROR_VIDEO_PROFILE_OPERATION_NOT_SUPPORTED_KHR    = -1000023002,
  err_video_notSupported_pictureLayout      = -1000023001 , # VK_ERROR_VIDEO_PICTURE_LAYOUT_NOT_SUPPORTED_KHR       = -1000023001,
  err_image_notSupported_usage              = -1000023000 , # VK_ERROR_IMAGE_USAGE_NOT_SUPPORTED_KHR                = -1000023000,
  err_outOfPoolMemory                       = -1000069000 , # VK_ERROR_OUT_OF_POOL_MEMORY                           = -1000069000,
  err_invalid_shader                        = -1000012000 , # VK_ERROR_INVALID_SHADER_NV                            = -1000012000,
  err_validationFailed                      = -1000011001 , # VK_ERROR_VALIDATION_FAILED_EXT                        = -1000011001,
  err_incompatibleDisplay                   = -1000003001 , # VK_ERROR_INCOMPATIBLE_DISPLAY_KHR                     = -1000003001,
  err_outOfDate                             = -1000001004 , # VK_ERROR_OUT_OF_DATE_KHR                              = -1000001004,
  err_nativeWindow_inUse                    = -1000000001 , # VK_ERROR_NATIVE_WINDOW_IN_USE_KHR                     = -1000000001,
  err_surfaceLost                           = -1000000000 , # VK_ERROR_SURFACE_LOST_KHR                             = -1000000000,
  err_unknown                               = -13         , # VK_ERROR_UNKNOWN = -13,
  err_fragmentedPool                        = -12         , # VK_ERROR_FRAGMENTED_POOL = -12,
  err_formatNotSupported                    = -11         , # VK_ERROR_FORMAT_NOT_SUPPORTED = -11,
  err_tooManyObjects                        = -10         , # VK_ERROR_TOO_MANY_OBJECTS = -10,
  err_incompatibleDriver                    = -9          , # VK_ERROR_INCOMPATIBLE_DRIVER = -9,
  err_notPresent_feature                    = -8          , # VK_ERROR_FEATURE_NOT_PRESENT = -8,
  err_notPresent_extension                  = -7          , # VK_ERROR_EXTENSION_NOT_PRESENT = -7,
  err_notPresent_layer                      = -6          , # VK_ERROR_LAYER_NOT_PRESENT = -6,
  err_memoryMapFailed                       = -5          , # VK_ERROR_MEMORY_MAP_FAILED = -5,
  err_deviceLost                            = -4          , # VK_ERROR_DEVICE_LOST = -4,
  err_initFailed                            = -3          , # VK_ERROR_INITIALIZATION_FAILED = -3,
  err_outOfDeviceMemory                     = -2          , # VK_ERROR_OUT_OF_DEVICE_MEMORY = -2,
  err_outOfHostMemory                       = -1          , # VK_ERROR_OUT_OF_HOST_MEMORY = -1,

  ok                                        = 0           , # VK_SUCCESS = 0,

  notReady                                  = 1           , # VK_NOT_READY = 1,
  timeout                                   = 2           , # VK_TIMEOUT = 2,
  event_set                                 = 3           , # VK_EVENT_SET = 3,
  event_reset                               = 4           , # VK_EVENT_RESET = 4,
  incomplete                                = 5           , # VK_INCOMPLETE = 5,
  suboptimal                                = 1000001003  , # VK_SUBOPTIMAL_KHR = 1000001003,
  idle                                      = 1000268000  , # VK_THREAD_IDLE_KHR = 1000268000,
  done                                      = 1000268001  , # VK_THREAD_DONE_KHR = 1000268001,
  deferred                                  = 1000268002  , # VK_OPERATION_DEFERRED_KHR = 1000268002,
  notDeferred                               = 1000268003  , # VK_OPERATION_NOT_DEFERRED_KHR = 1000268003,
  compileRequired                           = 1000297000  , # VK_PIPELINE_COMPILE_REQUIRED = 1000297000,
  shaderBinary                              = 1000482000  , # VK_INCOMPATIBLE_SHADER_BINARY_EXT = 1000482000,
  pipelineBinaryMissing                     = 1000483000  , # VK_PIPELINE_BINARY_MISSING_KHR = 1000483000,

converter toBool *(val :Result) :bool=  not (val == Result.ok)

