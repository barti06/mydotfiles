{ self, inputs, ... }: {
    flake.nixosModules.barti-pcHome = {
        imports = [ inputs.home-manager.nixosModules.home-manager ];
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = { inherit inputs; };
            users.barti = self.homeModules.barti;
        };
    };

    flake.homeModules.barti = { config, pkgs, ... }: {
        home.username = "barti";
        home.homeDirectory = "/home/barti";
        home.stateVersion = "26.05";
        
        home.packages = with pkgs; [
            kitty
            spotify
            discord
        ];
        
        home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.apple-cursor;
            name = "macOS";
            size = 24;
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
            loginShellInit = ''
	            if test (tty) = /dev/tty1
	                set -x XDG_SESSION_TYPE wayland
                    set -x XDG_SESSION_DESKTOP niri
                    set -x XDG_CURRENT_DESKTOP niri
                    exec niri-session -l
	            end
	        '';
            interactiveShellInit = ''
                set fish_greeting ""
                set -g __fish_git_prompt_char_stateseparator ""
                set -g __fish_git_prompt_showdirtystate 1
                set -g __fish_git_prompt_char_dirtystate "*"
                fastfetch
            '';
            shellAliases = {
                ls = "eza -la --icons --group-directories-first";
                btw = "echo i use nixos, btw";
                nef = "cd ~/cfg && exec nvim";
                nrs = "sudo nixos-rebuild switch --flake ~/cfg#barti-pc";
            };
            functions = {
                fish_prompt = ''
                set -l git (fish_git_prompt | string trim -c '() ')
                set_color blue
                echo -n (prompt_pwd)
                set_color magenta
                echo " $git"
                echo -n "❯ "
                set_color normal
                '';
            };
        };
        
        programs.kitty = {
            enable = true;
            font = {
                name = "JetBrainsMono Nerd Font";
                size = 12;
            };
            settings = {
                background_opacity = "0.9";
            };
        };
    };
}
