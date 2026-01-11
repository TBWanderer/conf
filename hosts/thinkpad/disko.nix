# hosts/thinkpad/disko.nix - Disk layout for ThinkPad X1 Carbon Gen 13
{ ... }:

{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";  # Change if different
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
            
            # passwordFile = "/tmp/secret.key";  # For install
            
            content = {
              type = "btrfs";
              extraArgs = [ "-L" "nixos" "-f" ];
              
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "subvol=root" "compress=zstd:1" "noatime" "ssd" "discard=async" ];
                };
                
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [ "subvol=home" "compress=zstd:1" "noatime" "ssd" "discard=async" ];
                };
                
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "subvol=nix" "compress=zstd:3" "noatime" "ssd" "discard=async" ];
                };
                
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "subvol=persist" "compress=zstd:1" "noatime" "ssd" "discard=async" ];
                };
                
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [ "subvol=log" "compress=zstd:1" "noatime" "ssd" "discard=async" ];
                };
                
                "/swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "8G";  # Smaller for ultrabook
                };
              };
            };
          };
        };
      };
    };
  };
  
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
