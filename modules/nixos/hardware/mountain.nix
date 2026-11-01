# Mountain Everest 60 keyboard (USB vendor 3282): BaseCamp-Linux, plus raw USB/HID access for the
# logged-in user. Upstream's 99-mountain.rules also sets MODE="0666", which opens the keyboard's
# typing interface to every user; uaccess alone is enough. uaccess has to be tagged before
# 73-seat-late.rules, so this is a 70- rules file (services.udev.extraRules lands at 99).
{pkgs, ...}: {
  environment.systemPackages = [(pkgs.callPackage ../../../pkgs/basecamp-linux {})];

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "mountain-udev-rules";
      destination = "/etc/udev/rules.d/70-mountain.rules";
      text = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="3282", TAG+="uaccess"
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3282", TAG+="uaccess"
      '';
    })
  ];
}
