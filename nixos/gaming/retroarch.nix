# nixos/gaming/retroarch.nix
# RetroArch and standalone emulator configuration
{pkgs, ...}: let
  # Build RetroArch with selected cores
  retroarchWithCores = pkgs.retroarch.withCores (cores:
    with cores; [
      # Nintendo DS
      melonds # Nintendo DS emulator

      # Game Boy / Game Boy Advance
      mgba # Game Boy Advance emulator

      # Additional cores you might want:
      # snes9x                                          # Super Nintendo
      # mupen64plus                                     # Nintendo 64
      # genesis-plus-gx                                 # Sega Genesis/Mega Drive
      # pcsx-rearmed                                    # PlayStation 1
      # dolphin                                         # GameCube/Wii (use standalone for better performance)
      # ppsspp                                          # PlayStation Portable
      # desmume                                         # Alternative Nintendo DS core
      # nestopia                                        # NES
    ]);
in {
  # ============================================================================
  # Emulation Software
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Multi-System Emulator
    retroarchWithCores

    # Standalone Emulators (often better performance than RetroArch cores)
    ryubing # Nintendo Switch emulator (fork of Ryujinx)
    pcsx2 # PlayStation 2 emulator

    # Additional standalone emulators to consider:
    # rpcs3                                             # PlayStation 3 emulator
    # cemu                                              # Wii U emulator
    # yuzu                                              # Nintendo Switch (alternative to ryubing)
    # dolphin-emu                                       # Already in default.nix
    # ppsspp                                            # PlayStation Portable
    # duckstation                                       # PlayStation 1 (more accurate than PCSX)
  ];

  # ============================================================================
  # Optional: Controller Support
  # ============================================================================
  # Uncomment if you need specific controller drivers
  # hardware.xone.enable = true;                        # Xbox One/Series controllers
  # hardware.xpadneo.enable = true;                     # Xbox controllers via Bluetooth
}
