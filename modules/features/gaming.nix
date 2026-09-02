{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        ioprio = 0;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device_id = "03:00.0";
      };
      cpu = {
        park_cores = false;
        pin_cores = true;
      };
    };
  };

  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    gamemode
    mangohud
    wine
    winetricks
    heroic
    protontricks
    # bottles  // openldap is failing on ts
    # lutris
    dxvk
    pciutils
    prismlauncher
  ];
}
