{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    android-tools
    android-studio
  ];

  users.users.boi.extraGroups = ["adbusers" "kvm"];
}
