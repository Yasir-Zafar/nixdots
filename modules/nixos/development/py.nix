# A plain python3 for scripts, `py`, `serve` and `mkvenv`. Libraries live per project:
# templates/python (uv-managed .venv) or `uv add` in an existing one.
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3
    # previously installed globally:
    # (python3.withPackages (ps: with ps; [numpy pandas requests matplotlib]))
  ];
}
