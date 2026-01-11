# modules/shell/default.nix - Shell configuration
{ lib, pkgs, config, ... }:

let
  configPath = "/home/x/nixos-config";
in
{
  # System-wide shell programs
  programs = {
    fish.enable = true;
    starship.enable = true;
    
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  
  # Home-manager shell configuration
  home-manager.users.x = {
    programs = {
      fish = {
        enable = true;
        
        interactiveShellInit = ''
          set fish_greeting
          export NIXPKGS_ALLOW_UNFREE=1
          export EDITOR=nvim
          export DIRENV_LOG_FORMAT=""
        '';
        
        shellAliases = {
          # === Quick exits ===
          q = "exit";
          c = "clear";
          cls = "clear";
          
          # === Modern alternatives ===
          ls = "eza --icons";
          l = "eza -la --icons";
          ll = "eza -l --icons";
          la = "eza -la --icons";
          lt = "eza --tree --icons";
          cat = "bat";
          grep = "rg";
          find = "fd";
          ps = "procs";
          du = "dust";
          df = "duf";
          top = "btm";
          
          # === Editors ===
          o = "nvim";
          v = "nvim";
          vim = "nvim";
          
          # === Git ===
          lg = "lazygit";
          gs = "git status";
          ga = "git add";
          gc = "git commit";
          gp = "git push";
          gl = "git log --oneline -10";
          gd = "git diff";
          
          # === NixOS ===
          update = "nh os switch ${configPath}";
          rebuild = "sudo nixos-rebuild switch --flake ${configPath}";
          test = "sudo nixos-rebuild test --flake ${configPath}";
          gc-nix = "sudo nix-collect-garbage -d";
          
          # === System ===
          light = "brightnessctl s";
          vol = "pamixer --get-volume";
          
          # === Development shortcuts ===
          dev = "nix develop ${configPath}#dev";
          ctf = "nix develop ${configPath}#ctf";
          rust = "nix develop ${configPath}#rust";
          py = "nix develop ${configPath}#python";
          embedded = "nix develop ${configPath}#embedded";
        };
        
        functions = {
          # Quick directory creation and cd
          mkcd = "mkdir -p $argv[1] && cd $argv[1]";
          
          # Find and edit
          fe = "fd --type f | fzf | xargs -r nvim";
          
          # Git quick commit
          gca = "git add -A && git commit -m \"$argv\"";
          
          # IP info
          myip = "curl -s ifconfig.me";
          
          # Weather
          weather = "curl -s 'wttr.in/?format=3'";
        };
      };
      
      # Starship prompt
      starship = {
        enable = true;
        settings = {
          add_newline = false;
          
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[✗](bold red)";
          };
          
          directory = {
            truncation_length = 3;
            truncate_to_repo = true;
          };
          
          git_branch = {
            symbol = " ";
          };
          
          nix_shell = {
            symbol = " ";
            format = "[$symbol$state]($style) ";
          };
          
          rust.symbol = " ";
          python.symbol = " ";
          golang.symbol = " ";
        };
      };
      
      # Zoxide (smart cd)
      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
      
      # fzf fuzzy finder
      fzf = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
