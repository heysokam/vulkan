//:_____________________________________________________________________________________
//  Vulkan: All-the-Things  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:_____________________________________________________________________________________
// @deps std
use std::collections::HashSet;
use std::ffi::CStr;
use std::os::raw::c_void;
// @deps External
use anyhow::{anyhow, Result};
use vk::AllocationCallbacks;
use winit::window::Window;
use log::*;
// @deps Vulkan
use vulkanalia::Version;
use vulkanalia::loader::{LibloadingLoader, LIBRARY};
use vulkanalia::window as vk_window;
use vulkanalia::prelude::v1_0::*;
use vulkanalia::vk::ExtDebugUtilsExtension;


const portability_macos_version :Version= Version::new(1, 3, 216);
const cfg_api_version :u32= vk::make_version(1, 0, 0);
const cfg_validation_active :bool= cfg!(debug_assertions);


//______________________________________
// @section Validation
//____________________________
const validation_LayerName :vk::ExtensionName= vk::ExtensionName::from_bytes(b"VK_LAYER_KHRONOS_validation");


//______________________________________
// @section Debug
//____________________________
extern "system" fn debug_callback (
    severity : vk::DebugUtilsMessageSeverityFlagsEXT,
    type_    : vk::DebugUtilsMessageTypeFlagsEXT,
    data     : *const vk::DebugUtilsMessengerCallbackDataEXT,
    _        : *mut c_void,
  ) -> vk::Bool32 {
    let data    = unsafe { *data };
    let message = unsafe { CStr::from_ptr(data.message) }.to_string_lossy();
    if      severity >= vk::DebugUtilsMessageSeverityFlagsEXT::ERROR   { error!("({:?}) {}", type_, message); }
    else if severity >= vk::DebugUtilsMessageSeverityFlagsEXT::WARNING {  warn!("({:?}) {}", type_, message); }
    else if severity >= vk::DebugUtilsMessageSeverityFlagsEXT::INFO    { debug!("({:?}) {}", type_, message); }
    else                                                               { trace!("({:?}) {}", type_, message); }
    vk::FALSE
} //:: debug.callback

unsafe fn debug_create (
    I : Instance,
  ) -> Option<Result<vk::DebugUtilsMessengerEXT>> {
  if !cfg_validation_active { return None }
  let debug_info = vk::DebugUtilsMessengerCreateInfoEXT::builder()
    .message_severity(vk::DebugUtilsMessageSeverityFlagsEXT::all())
    .message_type(
      vk::DebugUtilsMessageTypeFlagsEXT::GENERAL    |
      vk::DebugUtilsMessageTypeFlagsEXT::VALIDATION |
      vk::DebugUtilsMessageTypeFlagsEXT::PERFORMANCE)
    .user_callback(Some(debug_callback));

  Some(I.create_debug_utils_messenger_ext(&debug_info, None)?)
}

//______________________________________
// @section Instance
//____________________________
unsafe fn instance_create (
    appName    : &[u8],
    appVers    : u32,
    engineName : &[u8],
    engineVers : u32,
    window     : &Window,
    entry      : &Entry,
    A          : Option<&AllocationCallbacks>,
  ) -> Result<Instance> {
  let mut extensions = vk_window::get_required_instance_extensions(window)
    .iter().map(|e| e.as_ptr()).collect::<Vec<_>>();
  if cfg_validation_active { extensions.push(vk::EXT_DEBUG_UTILS_EXTENSION.name.as_ptr()); }

  // Required by Vulkan SDK on macOS since 1.3.216.
  let flags = if cfg!(target_os = "macos") && entry.version()? >= portability_macos_version {
    info!("Enabling extensions for macOS portability.");
    extensions.push(vk::KHR_GET_PHYSICAL_DEVICE_PROPERTIES2_EXTENSION.name.as_ptr());
    extensions.push(vk::KHR_PORTABILITY_ENUMERATION_EXTENSION.name.as_ptr());
    vk::InstanceCreateFlags::ENUMERATE_PORTABILITY_KHR
  } else {
    vk::InstanceCreateFlags::empty()
  };

  if cfg_validation_active && !entry.enumerate_instance_layer_properties()?
      .iter().map(|l| l.layer_name).collect::<HashSet<_>>()
      .contains(&validation_LayerName) {
    return Err(anyhow!("Validation layer requested but not supported."));
  }

  let layers =
    if cfg_validation_active { vec![validation_LayerName.as_ptr()] }
    else { Vec::new() };

  Ok(entry.create_instance(&vk::InstanceCreateInfo::builder()
    .application_info(&vk::ApplicationInfo::builder()
      .application_name(appName)
      .application_version(appVers)
      .engine_name(engineName)
      .engine_version(engineVers)
      .api_version(cfg_api_version))
    .enabled_extension_names(&extensions)
    .enabled_layer_names(&layers)
    .flags(flags),
    A)?)
} //:: instance.create


#[derive(Clone, Debug)]
pub struct Gpu {
  A         :Option<AllocationCallbacks>,
  entry     :Entry,
  instance  :Instance,
  dbg       :vk::DebugUtilsMessengerEXT,
}

impl Gpu {
  pub unsafe fn init (window: &Window) -> Result<Self> { 
    // @section Configuration
    let appName    = b"rvk | Vulkan Tutorial\0";
    let appVers    = vk::make_version(0, 0, 0);
    let engineName = b"rvk | Engine\0";
    let engineVers = vk::make_version(0, 0, 0);

    // @section Load Vulkan
    let entry = Entry::new(LibloadingLoader::new(LIBRARY)?)
      .map_err(|b| anyhow!("{}", b))?;
    let A :Option<AllocationCallbacks>= None;

    let instance = instance_create(
      appName, appVers,
      engineName, engineVers,
      window, &entry, A.as_ref())?;
    let dbg = debug_create(instance);

    // @section Create the result
    Ok(Self {
      A        : A.clone(),
      entry    : entry.clone(),
      instance : instance,
      dbg      : dbg,
      })
  }
  pub unsafe fn update (&mut self, _window: &Window) -> Result<()> { Ok(()) }
  pub unsafe fn term (&mut self) {
    self.instance.destroy_instance(self.A.as_ref());
  }
}

#[derive(Clone, Debug, Default)]
pub struct GpuData {}

