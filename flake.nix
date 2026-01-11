{
  description = "NixOS configuration for Maibenben x525 and ThinkPad X1 Carbon Gen 13";

  inputs = {
    # Core inputs - version managed through lib/default.nix concept
    # Using nixos-unstable for latest features
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Theming
    stylix.url = "github:danth/stylix";
    
    # Development tools
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Applications
    firefox.url = "github:nix-community/flake-firefox-nightly";
    
    yandex-music = {
      url = "github:cucumber-sp/yandex-music-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    ayugram-desktop = {
      type = "git";
      submodules = true;
      url = "https://github.com/ndfined-crp/ayugram-desktop/";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # Import central configuration
      config = import ./lib { lib = nixpkgs.lib; };
      
      # Common special args for all hosts
      specialArgs = { 
        inherit inputs config; 
      };
      
      # Helper function to create a NixOS system
      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          # Core modules
          ./modules/core
          
          # Host-specific configuration
          ./hosts/${hostname}
          
          # External modules
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          stylix.nixosModules.stylix
          inputs.yandex-music.nixosModules.default
          
          # Common home-manager settings
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        maibenben = mkHost "maibenben";
        thinkpad = mkHost "thinkpad";
      };
      
      # Development shells for different tasks
      devShells.${system} = import ./devshells { 
        pkgs = nixpkgs.legacyPackages.${system}; 
        inherit inputs;
      };
    };
}
