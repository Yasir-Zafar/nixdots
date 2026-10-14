# programs.java installs the JDK and sets JAVA_HOME (previously done by hand)
{pkgs, ...}: {
  programs.java = {
    enable = true;
    package = pkgs.javaPackages.compiler.temurin-bin.jdk-21;
  };
}
