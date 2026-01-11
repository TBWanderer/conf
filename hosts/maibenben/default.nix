# hosts/maibenben/default.nix - Maibenben x525 with NVIDIA 4060
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
  networking.hostName = "maibenben";

  # ============================================================================
  # HARDWARE DETECTION
  # ============================================================================
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
