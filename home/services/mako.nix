{
  services.mako = {
    enable = true;
    backgroundColor = "#282828";     # Gruvbox dark
    textColor = "#ebdbb2";           # Gruvbox light
    borderColor = "#458588";         # Gruvbox blue
    borderSize = 2;
    borderRadius = 16;               # Rounded corners

    defaultTimeout = 5000;

    # Extra spacing
    padding = "20";                  # Inside each notification
    margin = "20";                   # Between notifications

    # Font and icon scaling
    font = "JetBrainsMono Nerd Font 14";  # Make sure font supports icons
    icons = true;
    iconPath = "/usr/share/icons";        # Adjust if using custom icon theme
    maxIconSize = 64;                     # Rounded icon size (larger than default)

    # Layout and anchoring
    width = 400;
    height = 200;
    anchor = "top-right";                 # You can change this
    maxVisible = 5;

    extraConfig = ''
      [urgency=low]
      background-color=#3c3836
      text-color=#bdae93
      border-color=#928374

      [urgency=critical]
      background-color=#cc241d
      text-color=#fbf1c7
      border-color=#fb4934
    '';
  };
}

