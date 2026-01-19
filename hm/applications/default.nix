# ============================================================================
# Home Manager Applications Configuration
# Location: hm/applications/default.nix
# ============================================================================
{
  imports = [
    # Terminal emulator
    ./ghostty.nix

    # Media applications (video, audio, images)
    ./media.nix

    # Utilities (file managers, system tools)
    ./utilities.nix

    # Audio effects daemon
    # ./easyeffect.nix # Uncomment if needed
  ];
}
