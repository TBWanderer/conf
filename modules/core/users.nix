# modules/core/users.nix - User configuration
{ pkgs, config, ... }:

let
  cfg = config;
in
{
  users.users = {
    x = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "docker"
        "vboxusers"
        "kvm"
        "networkmanager"
        "adbusers"
        "video"
        "audio"
        "input"
        "dialout"  # For serial ports (embedded dev)
      ];
    };
    
    root.shell = pkgs.fish;
  };
}
