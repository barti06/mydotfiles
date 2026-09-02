{
  config,
  pkgs,
  lib,
  ...
}:
let
  hardwareConfig = ./hardware.nix;
  disks = ./disks.nix;
  homeMananger = ./home.nix;
  headset-control = ../../features/headset-control.nix;
  sddm = ../../features/sddm.nix;
  devModule = ../../features/dev.nix;
  gamingModule = ../../features/gaming.nix;
  helium = ../../features/helium.nix;
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    hardwareConfig
    disks
    homeMananger

    sddm
    headset-control
    helium
    devModule
    gamingModule
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 20 * 1024;
    }
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.mononoki
    maple-mono.NF
    dejavu_fonts
    liberation_ttf
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    ipafont
  ];

  users.users.barti = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "corectrl"
      "vboxusers"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
    ];
  };
  users.extraGroups.vboxusers.members = [ "barti" ];

  systemd.coredump.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kusabimaru";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Buenos_Aires";

  services.getty.autologinUser = "barti";
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  services.flatpak.enable = true;
  services.udisks2.enable = true; # useless tbh

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = [ "dolphin.desktop" ];
    "application/x-gnome-saved-search" = [ "dolphin.desktop" ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire = {
      "99-corsair" = {
        "context.properties" = {
          "module.x11.bell" = false;
          "core.daemon" = true;
        };
      };
    };
  };

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    drkonqi
  ];
  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };
  # services.xserver.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.niri.enable = true;

  programs.corectrl.enable = true;
  programs.corectrl.gpuOverclock.enable = true;
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.ignore_min_pcap=1"
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      xz
    ];
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.10"
  ];

  #virtualisation.virtualbox = {
  #    host = {
  #        enable = true;
  #        enableExtensionPack = true;
  #    };
  #    guest = {
  #        enable = true;
  #        dragAndDrop = true;
  #    };
  #};

  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    gdb
    lldb_18
    xwayland-satellite
    jq
    psmisc
    eza
    unzip
    zip
    fastfetch
    stow
    neovim
    helix
    vim
    wget
    git
    wl-clipboard
    ripgrep
    fd
    fzf
    pwvucontrol
    ntfs3g
    polkit_gnome
    p7zip
    unrar
    easyeffects
    btop
    pkgs.xdg-utils
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";
}
