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

  programs.zsh = {
    enable = true;
    # home-manager's zsh (terminal/shell/zsh.nix) runs a cached `compinit -C`; the global one
    # in /etc/zshrc ran a full compinit + compaudit before it on every start (~25 ms)
    enableGlobalCompInit = false;
  };

  users.defaultUserShell = pkgs.zsh;
}
