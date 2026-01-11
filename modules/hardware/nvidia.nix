# modules/hardware/nvidia.nix - NVIDIA GPU configuration
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.hardware.gpu.nvidia;
in
{
  options.hardware.gpu.nvidia = {
    enable = mkEnableOption "NVIDIA GPU support";
    
    intelBusId = mkOption {
      type = types.str;
      default = "PCI:0:2:0";
      description = "Intel GPU PCI bus ID";
    };
    
    nvidiaBusId = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
      description = "NVIDIA GPU PCI bus ID";
    };
    
    primeOffload = mkOption {
      type = types.bool;
      default = true;
      description = "Use PRIME offload mode";
    };
  };
  
  config = mkIf cfg.enable {
    # Kernel parameters for NVIDIA
    boot = {
      kernelParams = [
        "kvm.enable_virt_at_load=0"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia.NVreg_TemporaryFilePath=/var/tmp"
        "nvidia-drm.modeset=1"
        "nvidia-drm.fbdev=1"
        "mem_sleep_default=deep"
        "ibt=off"
        "acpi_osi=Linux"
      ];
      
      initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      
      blacklistedKernelModules = [ "nouveau" ];
    };
    
    hardware = {
      nvidia-container-toolkit.enable = true;
      
      nvidia = {
        modesetting.enable = true;
        
        powerManagement = {
          enable = true;
          finegrained = false;
        };
        
        open = false;
        nvidiaSettings = true;
        
        prime = mkIf cfg.primeOffload {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = cfg.intelBusId;
          nvidiaBusId = cfg.nvidiaBusId;
        };
        
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
    
    services.xserver.videoDrivers = [ "nvidia" ];
    
    # Enable NVIDIA for Docker
    virtualisation.docker.enableNvidia = true;
    
    # VRAM preservation during suspend
    systemd.tmpfiles.rules = [ "d /var/tmp 1777 root root -" ];
    
    # Prevent systemd from freezing sessions during suspend
    systemd.services."systemd-suspend".environment = {
      SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
    };
    
    # NVIDIA environment variables
    environment.sessionVariables = {
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
    };
  };
}
