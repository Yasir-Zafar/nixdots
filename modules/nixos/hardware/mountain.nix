# Mountain Everest 60: BaseCamp-Linux + HID access via uaccess (not upstream's 0666); must be a 70- rules file
{pkgs, ...}: {
  environment.systemPackages = [pkgs.basecamp-linux];

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
