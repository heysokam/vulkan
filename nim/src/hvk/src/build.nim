from std/strformat import `&`
import confy

confy.cfg.nim.systemBin = off

Program.new(
  src  = cfg.srcDir/"hvk",
  args = @[
    "--passL:\"-lubsan\"",
    "--passL:\"-Wno-error=implicit-float-conversion\"",
    "--passC:\"-Wno-error=incompatible-function-pointer-types\"",
    "--passC:\"-fno-sanitize-trap=all\"",
    ].join(" "),
  ).build( run=true )

