# modules/programs/default.nix - User applications
{ lib, pkgs, config, inputs, ... }:

{
  imports = [
    ./virtualization.nix
    ./gaming.nix
    ./rust.nix
  ];

  # User packages via home-manager
  home-manager.users.x = {
    home = {
      username = "x";
      homeDirectory = "/home/x";
      stateVersion = config.stateVersion;
      
      packages = with pkgs; [
        # === From flake inputs ===
        inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
        inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
        
        # === Communication ===
        telegram-desktop
        vesktop         # Discord
        gajim           # XMPP
        
        # === Browsers ===
        chromium
        tor-browser
        
        # === Media ===
        transmission_4-gtk
        
        # === Productivity ===
        onlyoffice-desktopeditors
        obsidian
        
        # === Graphics ===
        kdePackages.kolourpaint
        aseprite
        pix
        
        # === Development ===
        android-studio
        
        # === Gaming/Mods ===
        prismlauncher
        r2modman
        
        # === Wine ===
        winetricks
        wineWowPackages.waylandFull
        
        # === Wayland tools ===
        wl-clipboard
        cliphist
        grim
        slurp
        swaybg
        
        # === Notifications ===
        libnotify
        swaynotificationcenter
        
        # === System utilities ===
        alsa-utils
        bluez
        bluetui
        wmctrl
        
        # === Terminal tools ===
        clock-rs
      ];
    };
    
    programs = {
      home-manager.enable = true;
      
      # Terminals
      kitty.enable = true;
      alacritty.enable = true;
      
      # Rofi launcher
      rofi = {
        enable = true;
        package = pkgs.rofi;
        extraConfig = {
          show-icons = true;
          modi = "run,drun,window,ssh";
          terminal = "alacritty";
          drun-display-format = "{icon} {name}";
          disable-history = false;
          hide-scrollbar = true;
          display-drun = "   Apps ";
          display-run = "   Run ";
          display-window = " 󰕰  Window ";
          display-ssh = " 󰴽  SSH ";
          sidebar-mode = true;
        };
      };
    };
  };
  
  # Yandex Music
  programs.yandex-music = {
    enable = true;
    tray.enable = true;
  };
}
