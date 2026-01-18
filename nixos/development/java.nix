# nixos/development/java.nix
{pkgs, ...}: {
  # System-wide language runtimes
  environment.systemPackages = with pkgs; [
    # Java
    temurin-bin

    # Build tools
    maven
    gradle
  ];

  # Java environment variables
  environment.variables = {
    JAVA_HOME = "${pkgs.jdk21}";
  };
}
