{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    temurin-bin
    maven
  ];

  environment.variables = {
    JAVA_HOME = "${pkgs.temurin-bin}";
  };
}
