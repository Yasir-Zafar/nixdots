# plain python3; libraries per project (templates/python, uv)
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3
    # previously installed globally:
    # (python3.withPackages (ps: with ps; [numpy pandas requests matplotlib]))
  ];
}
