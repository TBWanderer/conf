# modules/hardware/disko.nix - Disk partitioning with LUKS and Btrfs
{ lib, config, ... }:

with lib;

let
  cfg = config.hardware.disko;
in
{
  options.hardware.disko = {
    enable = mkEnableOption "Disko disk management";
    
    device = mkOption {
      type = types.str;
      default = "/dev/nvme0n1";
      description = "Primary disk device";
    };
    
    swapSize = mkOption {
      type = types.str;
      default = "16G";
      description = "Swap partition size";
    };
    
    useFido2 = mkOption {
      type = types.bool;
      default = false;
      description = "Use FIDO2 for LUKS unlock";
    };
  };
  
  config = mkIf cfg.enable {
    disko.devices.disk.main = {
      type = "disk";
      device = cfg.device;
      content = {
        type = "gpt";
        partitions = {
          # EFI System Partition
          ESP = {
            label = "boot";
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" "umask=0077" ];
            };
          };
          
          # LUKS encrypted root
          luks = {
            size = "100%";
            label = "luks";
            content = {
              type = "luks";
              name = "cryptroot";
              
              extraOpenArgs = [
                "--allow-discards"
                "--perf-no_read_workqueue"
                "--perf-no_write_workqueue"
              ];
              
              settings = mkIf cfg.useFido2 {
                crypttabExtraOpts = [
                  "fido2-device=auto"
                  "token-timeout=10"
                ];
              };
              
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "nixos" "-f" ];
                
                subvolumes = {
                  # Root subvolume
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "subvol=root"
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                      "discard=async"
                    ];
                  };
                  
                  # Home subvolume
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "subvol=home"
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                      "discard=async"
                    ];
                  };
                  
                  # Nix store (high compression)
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "subvol=nix"
                      "compress=zstd:3"
                      "noatime"
                      "ssd"
                      "discard=async"
                    ];
                  };
                  
                  # Persistent data (survives reinstalls)
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "subvol=persist"
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                      "discard=async"
                    ];
                  };
                  
                  # Logs
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "subvol=log"
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                      "discard=async"
                    ];
                  };
                  
                  # Swap subvolume
                  "/swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = cfg.swapSize;
                  };
                };
              };
            };
          };
        };
      };
    };
    
    # Ensure critical filesystems are available early
    fileSystems."/persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;
  };
}
