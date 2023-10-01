{ pkgs, ...  }:
{

  users.users.boi = {

    isNormalUser = true;
    home = "/home/boi";
    description = "Yasir Zafar";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];

  };

}
