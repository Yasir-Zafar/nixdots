# nixos/development/java.nix
# Java development environment
{pkgs, ...}: {
  # ============================================================================
  # Java Packages
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Java Development Kit
    temurin-bin # Eclipse Temurin (formerly AdoptOpenJDK)

    # Build Tools
    maven # Dependency management and build automation
    gradle # Build automation tool (Groovy/Kotlin DSL)

    # Optional: Additional Java tools
    # javaPackages.openjfx  # JavaFX for GUI applications
    # visualvm              # Visual profiler
  ];

  # ============================================================================
  # Environment Variables
  # ============================================================================
  environment.variables = {
    JAVA_HOME = "${pkgs.temurin-bin}";
  };

  # Optional: Set Java version alternatives
  # programs.java = {
  #   enable = true;
  #   package = pkgs.jdk21;
  # };
}
