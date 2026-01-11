# modules/core/default.nix - Core system configuration
{ lib, pkgs, config, inputs, ... }:

let
  cfg = config;  # Central config from lib/default.nix
in
{
  imports = [
    ./boot.nix
    ./nix.nix
    ./networking.nix
    ./security.nix
    ./users.nix
    ./locale.nix
    ./packages.nix
    ../desktop
    ../shell
    ../programs
  ];

  # ============================================================================
  # SYSTEM BASICS
  # ============================================================================
  system.stateVersion = cfg.stateVersion;
  
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  # ============================================================================
  # HARDWARE BASICS
  # ============================================================================
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # ============================================================================
  # AUDIO
  # ============================================================================
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  # ============================================================================
  # FONTS
  # ============================================================================
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    corefonts
  ];
}
