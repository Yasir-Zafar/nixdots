# nixos/development/android.nix
# Android development environment
{pkgs, ...}: {
  # ============================================================================
  # Android Development Tools
  # ============================================================================
  environment.systemPackages = with pkgs; [
    android-tools # ADB, fastboot, and other Android tools
    android-studio # Official Android IDE

    # Optional: Additional Android tools
    # scrcpy                # Display and control Android devices
    # androidsdk            # Android SDK (if you need more control)
  ];

  # ============================================================================
  # Android Development Configuration
  # ============================================================================
  # Add user to required groups
  users.users.boi.extraGroups = [
    "adbusers" # Required for ADB access
    "kvm" # Required for Android Emulator hardware acceleration
  ];

  # ============================================================================
  # Android Emulator Optimization
  # ============================================================================

  # Optional: Set Android SDK environment variables
  environment.variables = {
    ANDROID_HOME = "$HOME/Android/Sdk";
    ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
  };
}
