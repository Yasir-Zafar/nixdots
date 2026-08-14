{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      javaPackages.compiler.temurin-bin.jdk-25
    ];

    sessionVariables = {
      JAVA_HOME = "${pkgs.javaPackages.compiler.temurin-bin.jdk-25}";
    };
  };
}
