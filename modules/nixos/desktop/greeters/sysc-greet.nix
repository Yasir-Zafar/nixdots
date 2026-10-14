# sysc-greet on greetd (active), Gruvbox theme + ascii rain, running on niri itself.
{config, ...}: {
  services.sysc-greet = {
    enable = true;
    compositor = "niri";
    # greeter compositor: the same niri the session uses
    niriPackage = config.programs.niri.package;
  };

  # sysc-greet has no declarative config: it reads its saved choices from the
  # greeter's cache. Seed them (gruvbox + ascii rain) on every boot/switch.
  systemd.tmpfiles.rules = [
    "d /var/lib/greeter/.cache 0755 greeter greeter -"
    "d /var/lib/greeter/.cache/sysc-greet 0755 greeter greeter -"
    "f+ /var/lib/greeter/.cache/sysc-greet/preferences 0644 greeter greeter - {\\x22theme\\x22:\\x22Gruvbox\\x22,\\x22background\\x22:\\x22ascii-rain\\x22,\\x22follow_shell\\x22:false}"
  ];
}
