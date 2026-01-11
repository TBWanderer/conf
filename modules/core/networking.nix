# modules/core/networking.nix - Network configuration
{ lib, config, ... }:

let
  cfg = config;
in
{
  networking = {
    networkmanager.enable = true;
    
    nameservers = lib.mkDefault [
      "1.1.1.1"
      "8.8.8.8"
    ];
    
    firewall = {
      enable = true;
      # Add ports as needed per host
    };
  };
  
  # DNS resolution
  services.resolved.enable = true;
}
