# modules/hardware/power.nix - Power management for laptops/ultrabooks
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.hardware.power;
in
{
  options.hardware.power = {
    enable = mkEnableOption "Enhanced power management";
    
    profile = mkOption {
      type = types.enum [ "balanced" "powersave" "performance" ];
      default = "balanced";
      description = "Power management profile";
    };
  };
  
  config = mkIf cfg.enable {
    # TLP for power management
    services.tlp = {
      enable = true;
      settings = {
        # CPU settings
        CPU_SCALING_GOVERNOR_ON_AC = 
          if cfg.profile == "performance" then "performance"
          else "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = 
          if cfg.profile == "powersave" then "powersave"
          else "schedutil";
        
        CPU_ENERGY_PERF_POLICY_ON_AC = 
          if cfg.profile == "performance" then "performance"
          else "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = if cfg.profile == "powersave" then 0 else 1;
        
        # Platform profile (for modern Intel)
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        
        # USB autosuspend
        USB_AUTOSUSPEND = 1;
        
        # Audio power saving
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;
        
        # WiFi power management
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        
        # ThinkPad battery thresholds (for battery longevity)
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    
    # Thermald for Intel thermal management
    services.thermald.enable = true;
    
    # Power profiles daemon (alternative to TLP parts)
    # services.power-profiles-daemon.enable = true;
    
    # Kernel parameters for power saving
    boot.kernelParams = [
      "intel_pstate=active"
    ];
    
    # Reduce swappiness for SSDs
    boot.kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
    };
  };
}
