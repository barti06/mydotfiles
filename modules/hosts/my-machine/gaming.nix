{ self, inputs, ... }: {
  flake.nixosModules.barti-pcGaming = { pkgs, ... }: {
    programs.steam = {
        enable = true;
        protontricks.enable = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
        gamemode
        mangohud
        wine
        winetricks
        lutris
        heroic
        protontricks
        bottles
        dxvk
    ];
  };
}
