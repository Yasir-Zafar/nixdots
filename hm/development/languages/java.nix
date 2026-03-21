{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      jdk21
      maven
    ];

    sessionVariables = {
      JAVA_HOME = "${pkgs.jdk21}";
      MAVEN_OPTS = "-Xmx2g -XX:+UseG1GC";
    };

    file.".m2/settings.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                                    http://maven.apache.org/xsd/settings-1.0.0.xsd">

        <localRepository>''${user.home}/.m2/repository</localRepository>

        <pluginGroups>
          <pluginGroup>org.springframework.boot</pluginGroup>
        </pluginGroups>
      </settings>
    '';
  };
}
