# modules/desktop/hyprland.nix - Hyprland (minimal, power-efficient)
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.desktop.hyprland;
in
{
  options.desktop.hyprland = {
    enable = mkEnableOption "Hyprland window manager";
  };

  config = mkIf cfg.enable {
    # System-level Hyprland support
    programs.hyprland.enable = true;
    
    # Home-manager Hyprland configuration
    home-manager.users.x = { config, ... }: {
      # Disable stylix Hyprland theming (we use custom)
      stylix.targets.hyprland.enable = false;
      
      # Simple wallpaper service
      services.hyprpaper.enable = mkForce false;
      
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          # === Monitor Configuration ===
          monitor=,preferred,auto,1
          
          # === Variables ===
          $terminal = ${pkgs.alacritty}/bin/alacritty --working-directory /home/x/
          $fileManager = ${pkgs.nemo}/bin/nemo
          $menu = ${pkgs.rofi}/bin/rofi -show drun
          $mod = SUPER
          
          # === Startup ===
          exec-once = ${pkgs.swaybg}/bin/swaybg -c "#000000"
          exec-once = ${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store
          
          # === General Settings (Power Efficient) ===
          general {
            gaps_in = 2
            gaps_out = 4
            border_size = 1
            col.active_border = rgba(5588ffee)
            col.inactive_border = rgba(333333aa)
            resize_on_border = true
            allow_tearing = false
            layout = dwindle
          }
          
          # === Decoration (Minimal for Power Saving) ===
          decoration {
            rounding = 4
            active_opacity = 1.0
            inactive_opacity = 0.95
            
            blur {
              enabled = false  # Disabled for power saving
            }
          }
          
          decoration:shadow {
            enabled = false  # Disabled for power saving
          }
          
          # === Animations (Minimal) ===
          animations {
            enabled = true
            bezier = quick, 0.15, 0.85, 0.25, 1
            animation = windows, 1, 3, quick
            animation = windowsOut, 1, 3, quick, popin 80%
            animation = fade, 1, 3, quick
            animation = workspaces, 1, 3, quick
          }
          
          # === Layout ===
          dwindle {
            pseudotile = true
            preserve_split = true
          }
          
          master {
            new_status = master
          }
          
          # === Misc (Power Saving) ===
          misc {
            force_default_wallpaper = 0
            disable_hyprland_logo = true
            disable_splash_rendering = true
            vfr = true  # Variable framerate for power saving
          }
          
          # === Input ===
          input {
            kb_layout = us,ru
            kb_options = caps:escape,grp:win_space_toggle
            follow_mouse = 1
            sensitivity = 0
            
            touchpad {
              natural_scroll = false
              tap-to-click = true
            }
          }
          
          # ============================================
          # KEYBINDINGS
          # ============================================
          
          # === Window Management ===
          bind = $mod, C, killactive
          bind = $mod, F, togglefloating
          bind = $mod, O, pin
          bind = $mod, Y, togglesplit
          bind = $mod, U, fullscreen
          bind = $mod, M, exit
          bind = $mod SHIFT, L, exec, hyprlock
          
          # === Applications ===
          bind = $mod, RETURN, exec, ${pkgs.alacritty}/bin/alacritty msg create-window || ${pkgs.alacritty}/bin/alacritty
          bind = $mod, E, exec, ${pkgs.nemo}/bin/nemo
          bind = $mod, R, exec, ${pkgs.rofi}/bin/rofi -show drun
          bind = ALT, SPACE, exec, ${pkgs.rofi}/bin/rofi -show run
          
          # === Clipboard ===
          bind = $mod, V, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi}/bin/rofi -dmenu -p "Clipboard" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
          
          # === Screenshot ===
          bind = , PRINT, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
          
          # === Focus Navigation (vim-style) ===
          bind = $mod, H, movefocus, l
          bind = $mod, L, movefocus, r
          bind = $mod, K, movefocus, u
          bind = $mod, J, movefocus, d
          
          # === Window Movement ===
          bind = $mod CTRL SHIFT, H, movewindow, l
          bind = $mod CTRL SHIFT, L, movewindow, r
          bind = $mod CTRL SHIFT, K, movewindow, u
          bind = $mod CTRL SHIFT, J, movewindow, d
          
          # === Window Resize ===
          bind = $mod CTRL, H, resizeactive, -50 0
          bind = $mod CTRL, L, resizeactive, 50 0
          bind = $mod CTRL, K, resizeactive, 0 -50
          bind = $mod CTRL, J, resizeactive, 0 50
          
          # === Workspaces ===
          bind = $mod, 1, workspace, 1
          bind = $mod, 2, workspace, 2
          bind = $mod, 3, workspace, 3
          bind = $mod, 4, workspace, 4
          bind = $mod, 5, workspace, 5
          bind = $mod, 6, workspace, 6
          bind = $mod, 7, workspace, 7
          bind = $mod, 8, workspace, 8
          bind = $mod, 9, workspace, 9
          bind = $mod, 0, workspace, 10
          
          # === Move to Workspace ===
          bind = $mod SHIFT, 1, movetoworkspace, 1
          bind = $mod SHIFT, 2, movetoworkspace, 2
          bind = $mod SHIFT, 3, movetoworkspace, 3
          bind = $mod SHIFT, 4, movetoworkspace, 4
          bind = $mod SHIFT, 5, movetoworkspace, 5
          bind = $mod SHIFT, 6, movetoworkspace, 6
          bind = $mod SHIFT, 7, movetoworkspace, 7
          bind = $mod SHIFT, 8, movetoworkspace, 8
          bind = $mod SHIFT, 9, movetoworkspace, 9
          bind = $mod SHIFT, 0, movetoworkspace, 10
          
          # === Mouse ===
          bind = $mod, mouse_down, workspace, e+1
          bind = $mod, mouse_up, workspace, e-1
          bindm = $mod, mouse:272, movewindow
          bindm = $mod, mouse:273, resizewindow
          
          # === Media Keys ===
          bind = , XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t
          bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 2
          bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 2
          bind = , XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
          bind = , XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous
          bind = , XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next
          bind = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%
          bind = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-
          
          # === Window Rules ===
          windowrulev2 = suppressevent maximize, class:.*
        '';
      };
      
      # Hyprlock configuration
      programs.hyprlock = {
        enable = true;
        extraConfig = ''
          background {
            monitor =
            color = rgba(0, 0, 0, 1)
          }
          
          general {
            hide_cursor = true
            grace = 0
            disable_loading_bar = true
          }
          
          input-field {
            monitor =
            size = 250, 50
            outline_thickness = 2
            dots_size = 0.2
            dots_spacing = 0.35
            outer_color = rgba(50, 50, 50, 1)
            inner_color = rgba(0, 0, 0, 0.5)
            font_color = rgba(200, 200, 200, 1)
            fade_on_empty = false
            placeholder_text = Password...
            position = 0, -100
            halign = center
            valign = center
          }
          
          label {
            monitor =
            text = cmd[update:1000] echo "$(date +"%H:%M")"
            color = rgba(200, 200, 200, 1)
            font_size = 72
            font_family = JetBrainsMono NF
            position = 0, 100
            halign = center
            valign = center
          }
        '';
      };
    };
  };
}
