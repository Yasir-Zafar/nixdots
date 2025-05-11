{
  services.mako = {
    enable = true;
    settings = {
      background-color = "#282828";     # Gruvbox dark
      text-color = "#ebdbb2";           # Gruvbox light
      border-color = "#8ec07c";         # Gruvbox blue
      border-size = 2;
      border-radius = 16;               # Rounded corners

      default-timeout = 5000;

      # Extra spacing
      padding = "15";                  # Inside each notification
      margin = "15";                   # Between notifications

      # Font and icon scaling
      font = "JetBrainsMono Nerd Font 11";  # Make sure font supports icons
      icons = true;
      icon-path = "/usr/share/icons";        # Adjust if using custom icon theme
      max-icon-size = 64;                     # Rounded icon size (larger than default)

      # Layout and anchoring
      width = 400;
      height = 200;
      anchor = "top-right";                 # You can change this
      max-visible = 5;
    };
  };
}

