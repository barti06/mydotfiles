{ self, inputs, ... }: {
   
    flake.nixosModules.niri = { pkgs, lib, ... }: {
        programs.niri = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
        };
    };

    # note: i should stop using hyprlock and hyprpolkitagent and hyprshot but hyprslop feels soooooooo good :)
    perSystem = { pkgs, lib, self',... }: {
        packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
            inherit pkgs;
            settings = {

                spawn-at-startup = [
                    (lib.getExe self'.packages.myNoctalia)
                    (lib.getExe pkgs.kitty)
                    "gnome-keyring-daemon --start --components=secrets,pkcs11"
                    (lib.getExe self'.packages.myHyprlock)
                ];

                environment = {
                    XCURSOR_THEME = "macOS";
                    XCURSOR_SIZE = "24";
                };

                xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

                input = {
                    keyboard = {
                        xkb = {
                            layout = "us,latam";
                            options = "grp:alt_shift_toggle";
                        };
                        repeat-rate = 40;
                        repeat-delay = 250;
                    };
                    mouse = {
                        accel-profile = "flat";
                        accel-speed = 0.0;
                    };
                };

                outputs = {
                        "ASUSTek COMPUTER INC VG27AQA1A RALMQS044446" = {
                        mode = "2560x1440@165.003";
                        scale = 1.0;
                    };
                };
                layout = {
                    gaps = 8;
                    border = {
                        width = 2;
                        active-color = "#33ccffee";
                        inactive-color = "#595959aa";
                    };
                };

                prefer-no-csd = true;

                animations = {
                    slowdown = 1.0;
                };

                window-rules = [
                    {
                        matches = [{ is-active = true; }];
                        opacity = 1.0;
                    }
                ];

                binds = {
                    # applications
                    "Mod+Q".spawn-sh = lib.getExe pkgs.kitty;
                    "Mod+E".spawn-sh = lib.getExe pkgs.kdePackages.dolphin;
                    "Mod+R".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
                    "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
                    
                    # screenshots
                    "Mod+Insert".spawn-sh = "${lib.getExe pkgs.hyprshot} -m region --clipboard-only";
                    "Mod+Shift+Insert".spawn-sh = "${lib.getExe pkgs.hyprshot} -m output --clipboard-only";
                   
                    # window management
                    "Mod+C".close-window = {};
                    "Mod+V".toggle-window-floating = {};
                    "Mod+Ctrl+BackSpace".toggle-window-floating = {};
                    "Mod+F".maximize-column = {};
                    "Mod+G".fullscreen-window = {};
                    "Mod+Shift+C".center-column = {};

                    # exit niri
                    "Mod+M".quit = {};

                    # window focus
                    "Mod+Left".focus-column-left = {};
                    "Mod+Right".focus-column-right = {};
                    "Mod+Up".focus-window-up = {};
                    "Mod+Down".focus-window-down = {};

                    # move windows
                    "Mod+Shift+H".move-column-left = {};
                    "Mod+Shift+L".move-column-right = {};
                    "Mod+Shift+K".move-window-up = {};
                    "Mod+Shift+J".move-window-down = {};

                    # Workspaces
                    "Mod+1".focus-workspace = 1;
                    "Mod+2".focus-workspace = 2;
                    "Mod+3".focus-workspace = 3;
                    "Mod+4".focus-workspace = 4;
                    "Mod+5".focus-workspace = 5;
                    "Mod+6".focus-workspace = 6;
                    "Mod+7".focus-workspace = 7;
                    "Mod+8".focus-workspace = 8;
                    "Mod+9".focus-workspace = 9;

                    "Mod+Shift+1".move-window-to-workspace = 1;
                    "Mod+Shift+2".move-window-to-workspace = 2;
                    "Mod+Shift+3".move-window-to-workspace = 3;
                    "Mod+Shift+4".move-window-to-workspace = 4;
                    "Mod+Shift+5".move-window-to-workspace = 5;
                    "Mod+Shift+6".move-window-to-workspace = 6;
                    "Mod+Shift+7".move-window-to-workspace = 7;
                    "Mod+Shift+8".move-window-to-workspace = 8;
                    "Mod+Shift+9".move-window-to-workspace = 9;

                    # scroll workspaces
                    "Mod+WheelScrollDown".focus-workspace-down = {};
                    "Mod+WheelScrollUp".focus-workspace-up = {};

                    # audio
                    "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
                    "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
                    "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                    "XF86AudioMicMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

                    # media
                    "XF86AudioNext".spawn-sh = "playerctl next";
                    "XF86AudioPrev".spawn-sh = "playerctl previous";
                    "XF86AudioPlay".spawn-sh = "playerctl play-pause";
                    "XF86AudioPause".spawn-sh = "playerctl play-pause";
                };
            };
        };
    };
}
