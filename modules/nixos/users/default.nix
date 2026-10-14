{
  pkgs,
  my,
  ...
}: {
  imports = [
    ./locale.nix
    ./packages.nix
  ];

  users.users.${my.user} = {
    isNormalUser = true;
    description = my.fullName;

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "storage"
      "gamemode"
      "uinput"
    ];

    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;
}
