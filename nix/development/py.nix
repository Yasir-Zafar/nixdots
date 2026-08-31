{pkgs}: {
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps:
      with ps; [
        numpy
        pandas
        requests
        # Add any other packages you need for the months ahead
      ]))
  ];
}
