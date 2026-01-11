# modules/core/nix.nix - Nix package manager configuration
{ pkgs, config, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      show-trace = true;
      warn-dirty = false;
      
      # Trusted users for remote builds
      trusted-users = [ "root" "@wheel" ];
    };
    
    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    
    # Keep build dependencies for development
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
  
  # Enable nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;
}
