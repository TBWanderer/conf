# modules/desktop/stylix.nix - System-wide theming
{ lib, pkgs, config, ... }:

{
  stylix = {
    enable = true;
    
    # Solid black wallpaper (created if not exists)
    image = pkgs.runCommand "solid-black" {} ''
      ${pkgs.imagemagick}/bin/convert -size 1920x1080 xc:black $out
    '';
    
    opacity.terminal = 0.9;
    
    fonts = rec {
      sizes.terminal = 10;
      serif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono NF";
      };
      sansSerif = serif;
      monospace = serif;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    
    cursor = {
      name = "phinger-cursors-dark";
      size = 24;
      package = pkgs.phinger-cursors;
    };
    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";
  };

  # Home-manager stylix settings
  home-manager.users.x.stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      light = "Adwaita";
      dark = "Adwaita";
    };
  };
}
