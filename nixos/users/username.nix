# nixos/users/username.nix
{
  config,
  pkgs,
  ...
}: {
  # User-specific system configurations go here
  # This file is imported by default.nix
  # Add any system-level configurations specific to this user
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Asia/Karachi";
  console.keyMap = "us";

  # Example: User-specific system packages
  users.users.boi.packages = with pkgs; [
    # Replace "username"
    # User-specific system packages can go here
    # Most packages should be in Home Manager instead
  ];
}
