# sysc-greet on greetd (active), Gruvbox theme + ascii rain, running on niri itself.
{
  config,
  my,
  ...
}: {
  services.sysc-greet = {
    enable = true;
    compositor = "niri";
    # greeter compositor: the same niri the session uses
    niriPackage = config.programs.niri.package;
  };

  # no declarative config: seed its cache (theme, last user + session) on every boot/switch
  systemd.tmpfiles.rules = let
    prefs = builtins.replaceStrings ["\""] ["\\x22"] (builtins.toJSON {
      theme = "Gruvbox";
      background = "ascii-rain";
      follow_shell = false;
      border_style = "classic";
      ascii_index = 0;
      anim_speed = "normal";
      session = "Mango";
      username = my.user;
    });
  in [
    "d /var/lib/greeter/.cache 0755 greeter greeter -"
    "d /var/lib/greeter/.cache/sysc-greet 0755 greeter greeter -"
    "f+ /var/lib/greeter/.cache/sysc-greet/preferences 0644 greeter greeter - ${prefs}"
  ];
}
