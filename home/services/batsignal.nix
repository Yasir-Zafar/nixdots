{
  services.batsignal = {
    enable = true;
    package = pkgs.batsignal;
    extraArgs = [
      "-b"                     # Enable battery monitoring
      "-w" "30"                # Warn at 30%
      "-c" "15"                # Critical at 15%
      "-d" "5"                 # Poll every 5 seconds
      "-f" "100"               # Full threshold
      "-W" "DC NIGGA"          # Warning message
      "-F" "am too full"       # Full message
      "-C" "Kys"               # Critical message
    ];
  };
}

