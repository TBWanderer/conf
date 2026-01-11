# modules/programs/gaming.nix - Steam and gaming
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.programs.gaming;
in
{
  options.programs.gaming = {
    enable = mkEnableOption "Gaming support (Steam, etc.)";
  };
  
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
