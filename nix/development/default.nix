{pkgs, ...}: {
  imports = [
    ./nix.nix
    ./py.nix
    ./c.nix
  ];

  virtualisation.docker.enable = true;
  users.users.boi.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    glib
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    pipewire
    python3Packages.pygobject3
    python3Packages.gst-python
    libxcb-cursor
  ];
}
