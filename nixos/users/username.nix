{pkgs, ...}: {
  i18n.defaultLocale = "en_GB.UTF-8";

  time.timeZone = "Asia/Karachi";

  console.keyMap = "us";

  users.users.boi.packages = with pkgs; [];
}
