# hosts/maibenben/default.nix - Maibenben x525 with NVIDIA 4060
{ lib, pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware
  ];

  # ============================================================================
  # HOST IDENTITY
  # ============================================================================
  networking.hostName = "maibenben";

  # ============================================================================
  # HARDWARE CONFIGURATION
  # ============================================================================
  
  # NVIDIA GPU
  hardware.gpu.nvidia = {
    enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    primeOffload = true;
  };
  
  # Swap
  swapDevices = lib.mkForce [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;  # 16 GB
  }];

  # ============================================================================
  # DESKTOP ENVIRONMENT
  # ============================================================================
  desktop.gnome.enable = true;
  desktop.hyprland.enable = true;  # Available but not default
  
  # ============================================================================
  # GAMING & NVIDIA FEATURES
  # ============================================================================
  programs.gaming.enable = true;
  
  # ============================================================================
  # DNS WITH TAILSCALE
  # ============================================================================
  networking.nameservers = [
    "100.126.179.69"  # Tailscale DNS
    "1.1.1.1"
    "8.8.8.8"
  ];
}
