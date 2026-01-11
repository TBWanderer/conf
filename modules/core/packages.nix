# modules/core/packages.nix - System-wide packages
{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # === Core utilities ===
    vim
    wget
    curl
    git
    file
    tree
    unzip
    zip
    p7zip
    
    # === Modern CLI tools ===
    bat           # cat replacement
    bottom        # htop replacement
    delta         # diff tool
    doggo         # DNS client
    duf           # df replacement
    dust          # du replacement
    eza           # ls replacement
    fd            # find replacement
    ripgrep       # grep replacement
    procs         # ps replacement
    zoxide        # cd replacement
    
    # === Development ===
    gcc
    gnumake
    nasm
    go
    python3
    python3Packages.pip
    
    # === System tools ===
    brightnessctl
    pamixer
    wireguard-tools
    xdg-utils
    calc
    fastfetch
    
    # === Git tools ===
    github-cli
    lazygit
    
    # === Network tools ===
    gping
    
    # === Editors ===
    neovim
    
    # === NixOS helpers ===
    nh            # Nix helper
  ];

  # Enable common programs
  programs = {
    git.enable = true;
    fish.enable = true;
    starship.enable = true;
  };
}
