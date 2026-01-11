# modules/core/boot.nix - Boot and kernel configuration
{ lib, pkgs, config, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        efiInstallAsRemovable = true;
        efiSupport = true;
        device = "nodev";
        theme = lib.mkDefault (pkgs.catppuccin-grub.overrideAttrs { 
          flavor = "macchiato"; 
        });
      };
    };

    supportedFilesystems = [ "ntfs" "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    
    kernelModules = [ "tcp_bbr" ];
    
    # Network performance tuning
    kernel.sysctl = {
      # Security hardening
      "kernel.sysrq" = 0;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv4.tcp_rfc1337" = 1;
      
      # Performance tuning
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };
  };
}
