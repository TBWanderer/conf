# hosts/thinkpad/default.nix - ThinkPad X1 Carbon Gen 13 Aura
{ lib, pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware
  ];

  # ============================================================================
  # HOST IDENTITY
  # ============================================================================
  networking.hostName = "thinkpad";

  # ============================================================================
  # HARDWARE CONFIGURATION
  # ============================================================================
  
  # Intel integrated graphics (no NVIDIA)
  hardware.gpu.nvidia.enable = false;
  
  # Power management for ultrabook
  hardware.power = {
    enable = true;
    profile = "balanced";  # Options: "balanced", "powersave", "performance"
  };
  
  # Intel CPU optimizations
  boot.kernelParams = [
    "intel_pstate=active"
    "i915.enable_fbc=1"           # Framebuffer compression
    "i915.enable_psr=1"           # Panel self refresh
  ];
  
  # Smaller swap for ultrabook
  swapDevices = lib.mkForce [{
    device = "/var/lib/swapfile";
    size = 8 * 1024;  # 8 GB
  }];

  # ============================================================================
  # DESKTOP ENVIRONMENT
  # ============================================================================
  desktop.gnome.enable = true;
  desktop.hyprland.enable = true;
  
  # ============================================================================
  # THINKPAD-SPECIFIC
  # ============================================================================
  
  # Fingerprint reader (if available)
  services.fprintd.enable = true;
  
  # Firmware updates
  services.fwupd.enable = true;
  
  # ============================================================================
  # NO GAMING ON ULTRABOOK
  # ============================================================================
  programs.gaming.enable = false;
}
