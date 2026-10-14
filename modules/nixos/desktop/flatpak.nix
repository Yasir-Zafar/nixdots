# Flatpaks as config (nix-flatpak). The flatpak service itself is enabled in
# greeters/common.nix; flathub is added as a remote by default.
# Only what is listed here is managed: other flatpaks and runtimes are left alone
# (uninstallUnmanaged stays off).
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
