{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; };
    users.barti =
      { config, pkgs, ... }:
      let
        hostname = "kusabimaru";
      in
      {
        home.username = "barti";
        home.homeDirectory = "/home/barti";
        home.stateVersion = "25.11";

        home.packages = with pkgs; [
          kitty
          spotify
          vesktop
          kdePackages.okular
          papirus-icon-theme
          ffmpeg
          ffmpegthumbnailer
          evince
          corectrl
          qdiskinfo
          scrcpy
          universal-android-debloater
          libreoffice
          mpv
          yt-dlg
          ventoy-full
          qbittorrent
          rofi
          waybar
          hyprpaper
          hyprshot
          swaynotificationcenter
          gimp
          kdePackages.kolourpaint
          tmux
          hyprlock
          man-pages
          xournalpp
          luarocks
          tree-sitter
          nodejs
          lua5_1
        ];

        services.swaync = {
          enable = true;
        };

        home.pointerCursor = {
          gtk.enable = true;
          package = pkgs.apple-cursor;
          name = "macOS";
          size = 24;
        };

        gtk = {
          enable = true;
          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };
        };

        xdg.configFile = {
          "fastfetch/config.jsonc".source = ./fastfetch.jsonc;
        };

        programs.git = {
          enable = true;
          package = pkgs.gitFull;
          settings = {
            user = {
              name = "barti06";
              email = "bartipdl1@gmail.com";
            };
            credential.helper = "${pkgs.gh}/bin/gh auth git-credential";
          };
        };

        programs.gh = {
          enable = true;
        };

        programs.fish = {
          enable = true;
          # loginShellInit = ''
          #    if test (tty) = /dev/tty1
          #       exec niri-session -l
          #   end
          # '';
          interactiveShellInit = ''
            set fish_greeting ""

            # git settings
            set -g __fish_git_prompt_char_stateseparator ""
            set -g __fish_git_prompt_showdirtystate 1
            set -g __fish_git_prompt_char_dirtystate "*"
          '';
          shellAliases = {
            ls = "eza -la --icons --group-directories-first";
            btw = "echo i use nixos, btw";
            "!edit" = "cd ~/cfg && hx";
            "!rebuild" = "sudo nixos-rebuild switch --flake ~/cfg#${hostname}";
            "!plasma" = "dbus-run-session startplasma-wayland";
            "!niri" = "niri-session";
          };
          functions = {
            fish_prompt = ''
              set -l git (fish_git_prompt | string trim -c '() ')

              set_color red
              echo -n "$USER"

              set_color blue
              echo " $git"

              set_color yellow
              echo -n (prompt_pwd)

              set_color normal
              echo -n ' φ '

              set_color normal
            '';
            fish_right_prompt = ''
              set_color 555
              echo -n "[$(date +%H:%M:%S)] "
              set_color normal
            '';
          };
        };

        systemd.user.services.corectrl = {
          Unit = {
            Description = "CoreCtrl (Background Service)";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };

          Service = {
            ExecStart = "${pkgs.corectrl}/bin/corectrl --minimize-systray";
            Restart = "on-failure";
            RestartSec = 5;
          };

          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };
      };
  };
}
