# modules/desktop/default.nix - Desktop environment configuration
{ lib, pkgs, config, ... }:

{
  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./stylix.nix
  ];

  # XDG Portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Common desktop services
  services = {
    libinput.enable = true;
    blueman.enable = true;
  };
}
