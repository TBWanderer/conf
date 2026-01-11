# modules/programs/rust.nix - Rust development environment
{ lib, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];
  
  environment.systemPackages = [
    (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
        "rustfmt"
        "clippy"
        "llvm-tools-preview"
      ];
      targets = [
        "x86_64-unknown-linux-gnu"
        "x86_64-unknown-linux-musl"
        "x86_64-pc-windows-gnu"
        "thumbv6m-none-eabi"      # Cortex-M0/M0+
        "thumbv7em-none-eabihf"   # Cortex-M4F/M7F
        "riscv32imac-unknown-none-elf"  # RISC-V
      ];
    }))
    pkgs.cargo-cross
    pkgs.cargo-watch
    pkgs.cargo-expand
  ];
  
  # Add cargo to PATH
  environment.variables.PATH = "/home/x/.cargo/bin:$PATH";
  environment.sessionVariables.PATH = "/home/x/.cargo/bin:$PATH";
}
