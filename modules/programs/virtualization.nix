# modules/programs/virtualization.nix - Docker, VirtualBox
{ lib, pkgs, config, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
    
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };
  };
}
