# nixos/desktop/fonts.nix
# Font configuration and packages
{pkgs, ...}: {
  # ============================================================================
  # Font Configuration
  # ============================================================================
  fonts.fontconfig = {
    enable = true;

    # Default font families for different use cases
    defaultFonts = {
      serif = ["Source Serif Pro" "DejaVu Serif"];
      sansSerif = ["Inter" "DejaVu Sans"];
      monospace = ["JetBrains Mono" "DejaVu Sans Mono"];
      emoji = ["Noto Color Emoji"];
    };

    # Subpixel rendering for LCD screens
    subpixel = {
      rgba = "rgb"; # Standard RGB pixel layout
      lcdfilter = "default"; # Apply LCD filtering
    };

    # Font hinting for sharper text
    hinting = {
      enable = true;
      style = "slight"; # Light hinting preserves font design
    };
  };

  # ============================================================================
  # Font Packages
  # ============================================================================
  fonts.packages = with pkgs; [
    # ---------------------------------------------------------------------------
    # Programming & Monospace Fonts
    # ---------------------------------------------------------------------------
    jetbrains-mono # Excellent coding font with ligatures
    fira-code # Popular coding font with ligatures
    inconsolata # Classic monospace font
    iosevka # Customizable programming font
    atkinson-monolegible # Accessible monospace font

    # ---------------------------------------------------------------------------
    # UI & System Fonts
    # ---------------------------------------------------------------------------
    inter # Modern UI font (used by GitHub, Figma)
    roboto # Google's default Android font
    source-sans-pro # Adobe's clean sans-serif
    source-serif-pro # Adobe's serif companion
    ubuntu-classic # Ubuntu's distinctive font
    atkinson-hyperlegible # Highly readable font for accessibility

    # ---------------------------------------------------------------------------
    # Standard Font Collections
    # ---------------------------------------------------------------------------
    dejavu_fonts # Comprehensive Unicode coverage
    liberation_ttf # Microsoft font metric-compatible
    freetype # Font rendering library

    # ---------------------------------------------------------------------------
    # International & CJK Support
    # ---------------------------------------------------------------------------
    noto-fonts # Google's comprehensive font family
    noto-fonts-cjk-sans # Chinese, Japanese, Korean support
    noto-fonts-color-emoji # Color emoji support

    # ---------------------------------------------------------------------------
    # Icon & Symbol Fonts
    # ---------------------------------------------------------------------------
    font-awesome # Popular icon font
    material-icons # Google Material Design icons
    material-design-icons # Extended Material Design icons
  ];
}
