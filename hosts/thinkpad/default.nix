# hosts/thinkpad/default.nix - ThinkPad X1 Carbon Gen 13 Aura
{ lib, pkgs, config, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
    ../../modules/hardware
  ];

  # ============================================================================
  # HOST IDENTITY
  # ============================================================================
  networking.hostName = "thinkpad";

  # ============================================================================
  # HARDWARE DETECTION
  # ============================================================================
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
