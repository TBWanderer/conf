# modules/desktop/gnome.nix - GNOME Desktop Environment
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.desktop.gnome;
  extensionUuids = map (ext: ext.extensionUuid) cfg.extensions;
in
{
  options.desktop.gnome = {
    enable = mkEnableOption "GNOME Desktop Environment";
    
    extensions = mkOption {
      type = types.listOf types.package;
      default = with pkgs.gnomeExtensions; [
        toggle-proxy
        appindicator
        clipboard-indicator
      ];
      description = "GNOME Shell extensions to install";
    };
    
    excludePackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        cheese epiphany evince geary
        gnome-characters gnome-music gnome-photos
        gnome-tour hitori iagno tali totem
        yelp gnome-maps gnome-weather simple-scan
        snapshot
      ];
      description = "GNOME packages to exclude";
    };
    
    favoriteApps = mkOption {
      type = types.listOf types.str;
      default = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Settings.desktop"
      ];
      description = "Favorite apps in dock";
    };
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };
      
      displayManager = {
        gdm.enable = true;
        defaultSession = "gnome";
      };
      
      desktopManager.gnome.enable = true;
      udev.packages = [ pkgs.gnome-settings-daemon ];
    };

    environment = {
      gnome.excludePackages = cfg.excludePackages;
      systemPackages = cfg.extensions ++ (with pkgs; [
        adwaita-icon-theme
        gnome-tweaks
      ]);
    };

    # GNOME dconf settings via home-manager
    home-manager.users.x.dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = extensionUuids;
        favorite-apps = cfg.favoriteApps;
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        clock-show-weekday = true;
        show-battery-percentage = true;
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        num-workspaces = 5;
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = false;
        edge-tiling = true;
        workspaces-only-on-primary = true;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = 3600;
        sleep-inactive-battery-timeout = 900;
        power-button-action = "suspend";
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
        natural-scroll = true;
      };

      "org/gnome/desktop/privacy" = {
        remember-recent-files = true;
        recent-files-max-age = 30;
        remove-old-temp-files = true;
        remove-old-trash-files = true;
      };

      "org/gtk/settings/file-chooser" = {
        sort-directories-first = true;
      };

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        show-delete-permanently = true;
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = ["<Super>c"];
        switch-applications = [];
        switch-windows = ["<Alt>Tab"];
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = true;
        night-light-temperature = mkDefault 3700;
      };
    };
  };
}
