{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      javaPackages.compiler.temurin-bin.jdk-21
    ];

    sessionVariables = {
      JAVA_HOME = "${pkgs.javaPackages.compiler.temurin-bin.jdk-21}";
    };
  };
}
