{pkgs, ...}: {
  imports = [
    ./username.nix
  ];

  users.users.boi = {
    isNormalUser = true;
    description = "Yasir Zafar";

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "storage"
      "gamemode"
      "kvm"
      "input"
      "uinput"
    ];

    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;
}
