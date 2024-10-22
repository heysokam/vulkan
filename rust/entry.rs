//:_____________________________________________________________________________________
//  Vulkan: All-the-Things  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:_____________________________________________________________________________________
#![allow(
  dead_code,
  clippy::too_many_arguments,
  clippy::unnecessary_wraps
)]

use anyhow::Result;
use winit::dpi::LogicalSize;
use winit::event::{Event, WindowEvent};
use winit::event_loop::EventLoop;
use winit::window::WindowBuilder;

mod gpu;
use crate::gpu::Gpu;

fn main() -> Result<()> {
  pretty_env_logger::init();

  // Window
  let event_loop = EventLoop::new()?;
  let window = WindowBuilder::new()
    .with_title("Vulkan Tutorial (Rust)")
    .with_inner_size(LogicalSize::new(1024, 768))
    .build(&event_loop)?;

  // App
  let mut app = unsafe { Gpu::init(&window)? };
  event_loop.run(move |event, elwt| { match event {
    // Request a redraw when all events were processed.
    Event::AboutToWait => window.request_redraw(),
    Event::WindowEvent { event, .. } => match event {
      // Render a frame if our Vulkan app is not being destroyed.
      WindowEvent::RedrawRequested if !elwt.exiting() => unsafe { app.update(&window) }.unwrap(),
      // Destroy our Vulkan app.
      WindowEvent::CloseRequested => {
        elwt.exit();
        unsafe { app.term(); }
      }
      _ => {}
    }
    _ => {}
  }})?;
  Ok(())
}

