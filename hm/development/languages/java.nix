# hm/development/languages/java.nix
{
  config,
  pkgs,
  ...
}: {
  home = {
    # Java development packages
    packages = with pkgs; [
      # Build tools
      maven
      gradle

      # Java tools
      jdk21
      visualvm

      # Spring Boot CLI (if you use Spring)
      spring-boot-cli
    ];

    # Java environment variables
    sessionVariables = {
      JAVA_HOME = "${pkgs.jdk21}";
      MAVEN_OPTS = "-Xmx2g";
    };

    # Maven configuration
    file.".m2/settings.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
        <localRepository>''${user.home}/.m2/repository</localRepository>
      </settings>
    '';
  };
}
