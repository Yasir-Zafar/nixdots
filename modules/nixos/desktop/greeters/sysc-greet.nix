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

  # sysc-greet has no declarative config: it reads its saved choices from the greeter's
  # cache. Seed them (gruvbox + ascii rain) on every boot/switch. The file is rewritten
  # each time, so the last user and session are part of the seed: sysc-greet only
  # prefills the username when the saved session matches the selected one ("Niri" is the
  # Name in niri's session file), then jumps straight to the password.
  systemd.tmpfiles.rules = let
    prefs = builtins.replaceStrings ["\""] ["\\x22"] (builtins.toJSON {
      theme = "Gruvbox";
      background = "ascii-rain";
      follow_shell = false;
      border_style = "classic";
      ascii_index = 0;
      anim_speed = "normal";
      session = "Niri";
      username = my.user;
    });
  in [
    "d /var/lib/greeter/.cache 0755 greeter greeter -"
    "d /var/lib/greeter/.cache/sysc-greet 0755 greeter greeter -"
    "f+ /var/lib/greeter/.cache/sysc-greet/preferences 0644 greeter greeter - ${prefs}"
  ];
}
