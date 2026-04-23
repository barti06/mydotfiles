{ self, inputs, ... }: {
    
    flake.nixosModules.barti-pcConfiguration = { pkgs, lib, ... }: {
        
        nixpkgs.config.allowUnfree = true;
        imports = [
            self.nixosModules.barti-pcHardware
            self.nixosModules.barti-pcGaming
            self.nixosModules.barti-pcDev
            self.nixosModules.barti-pcHome
            self.nixosModules.niri
        ];

        fonts.packages = with pkgs; [
            nerd-fonts.jetbrains-mono
        ];
    
        users.users.barti = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
            shell = pkgs.fish;
            packages = with pkgs; [
                tree
            ];
        };
        
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "barti-pc";
        networking.networkmanager.enable = true;
        time.timeZone = "America/Buenos_Aires";

        services.getty.autologinUser = "barti";
        services.gnome.gnome-keyring.enable = true;

        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };

        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };

        programs.fish.enable = true;
        programs.firefox.enable = true;

        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        system.stateVersion = "26.05";

        fileSystems."/mnt/ssd-sata" = {
            device = "/dev/disk/by-uuid/6EACD427ACD3E79B";
            fsType = "ntfs-3g";
            options = [ "rw" "uid=1000" "gid=100" "umask=0022" ];
        };

        environment.systemPackages = with pkgs; [
            jq
            psmisc
            eza
            unzip
            zip
            fastfetch
            stow
            neovim
            vim
            wget
            git
            wl-clipboard
            ripgrep
            fd
            fzf
            pwvucontrol
            ntfs3g
        ];

        environment.sessionVariables = {
            FILE_MANAGER = "nemo";
        };
    };
}
