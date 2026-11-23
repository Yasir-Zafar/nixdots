# flatpaks as config (nix-flatpak); only listed ones are managed
{
  services.flatpak = {
    packages = [
      "org.vinegarhq.Sober" # Roblox
    ];

    # weekly `flatpak update` through a systemd timer, not on every rebuild
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
