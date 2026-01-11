# devshells/default.nix - Development environments for various tasks
{ pkgs, inputs }:

let
  # Common packages for all shells
  commonPkgs = with pkgs; [
    git
    neovim
    ripgrep
    fd
    bat
  ];
in
{
  # ============================================================================
  # GENERAL DEVELOPMENT
  # ============================================================================
  dev = pkgs.mkShell {
    name = "dev";
    packages = commonPkgs ++ (with pkgs; [
      # Editors
      helix
      
      # Build tools
      gnumake
      cmake
      ninja
      pkg-config
      
      # Debugging
      gdb
      lldb
      valgrind
      
      # Documentation
      man-pages
      man-pages-posix
    ]);
    
    shellHook = ''
      echo "🔧 Development shell ready"
    '';
  };
  
  # ============================================================================
  # CTF / SECURITY
  # ============================================================================
  ctf = pkgs.mkShell {
    name = "ctf";
    packages = commonPkgs ++ (with pkgs; [
      # Binary analysis
      ghidra
      radare2
      binwalk
      hexyl
      file
      
      # Exploitation
      pwntools
      python3Packages.pwntools
      gdb
      pwndbg
      
      # Network
      wireshark
      nmap
      netcat-openbsd
      tcpdump
      
      # Crypto
      python3Packages.pycryptodome
      openssl
      hashcat
      john
      
      # Web
      burpsuite
      gobuster
      sqlmap
      
      # Forensics
      foremost
      volatility3
      exiftool
      
      # Misc
      python3Full
      python3Packages.requests
      python3Packages.beautifulsoup4
      z3
    ]);
    
    shellHook = ''
      echo "🏴 CTF environment ready"
      echo "Available: ghidra, radare2, pwntools, wireshark, nmap..."
    '';
  };
  
  # ============================================================================
  # RUST DEVELOPMENT
  # ============================================================================
  rust = pkgs.mkShell {
    name = "rust";
    packages = commonPkgs ++ (with pkgs; [
      # Rust toolchain (from overlay)
      (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
        extensions = [ "rust-src" "rust-analyzer" "rustfmt" "clippy" ];
      }))
      
      # Build dependencies
      pkg-config
      openssl
      
      # Cargo tools
      cargo-watch
      cargo-expand
      cargo-edit
      cargo-audit
      cargo-flamegraph
      
      # Cross compilation
      cargo-cross
    ]);
    
    shellHook = ''
      echo "🦀 Rust development shell ready"
      rustc --version
    '';
    
    RUST_SRC_PATH = "${pkgs.rust-bin.selectLatestNightlyWith (t: t.default)}/lib/rustlib/src/rust/library";
  };
  
  # ============================================================================
  # PYTHON DEVELOPMENT
  # ============================================================================
  python = pkgs.mkShell {
    name = "python";
    packages = commonPkgs ++ (with pkgs; [
      python3Full
      python3Packages.pip
      python3Packages.virtualenv
      python3Packages.ipython
      python3Packages.black
      python3Packages.pylint
      python3Packages.pytest
      python3Packages.numpy
      python3Packages.pandas
      python3Packages.requests
      python3Packages.flask
      python3Packages.fastapi
      poetry
    ]);
    
    shellHook = ''
      echo "🐍 Python development shell ready"
      python --version
    '';
  };
  
  # ============================================================================
  # EMBEDDED / HARDWARE
  # ============================================================================
  embedded = pkgs.mkShell {
    name = "embedded";
    packages = commonPkgs ++ (with pkgs; [
      # Rust for embedded
      (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
        extensions = [ "rust-src" "llvm-tools-preview" ];
        targets = [
          "thumbv6m-none-eabi"
          "thumbv7em-none-eabihf"
          "riscv32imac-unknown-none-elf"
        ];
      }))
      
      # ARM toolchain
      gcc-arm-embedded
      
      # Flashing tools
      openocd
      stlink
      dfu-util
      picotool
      
      # Serial communication
      minicom
      picocom
      screen
      
      # Python for MicroPython/CircuitPython
      python3Full
      python3Packages.pyserial
      python3Packages.esptool
      
      # Logic analyzer
      sigrok-cli
      pulseview
      
      # USB tools
      usbutils
      libusb1
      
      # Debugging
      probe-rs
      cargo-embed
    ]);
    
    shellHook = ''
      echo "🔌 Embedded development shell ready"
      echo "Targets: ARM Cortex-M, RISC-V, ESP32..."
    '';
  };
  
  # ============================================================================
  # WEB DEVELOPMENT
  # ============================================================================
  web = pkgs.mkShell {
    name = "web";
    packages = commonPkgs ++ (with pkgs; [
      nodejs_22
      nodePackages.npm
      nodePackages.pnpm
      nodePackages.yarn
      nodePackages.typescript
      nodePackages.typescript-language-server
      
      # Frameworks
      nodePackages.vite
      
      # Utilities
      jq
      httpie
    ]);
    
    shellHook = ''
      echo "🌐 Web development shell ready"
      node --version
    '';
  };
  
  # ============================================================================
  # GO DEVELOPMENT
  # ============================================================================
  go = pkgs.mkShell {
    name = "go";
    packages = commonPkgs ++ (with pkgs; [
      go
      gopls
      golangci-lint
      delve
      gotools
    ]);
    
    shellHook = ''
      echo "🐹 Go development shell ready"
      go version
    '';
  };
}
