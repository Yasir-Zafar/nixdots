# nixos/services/audio.nix
{
  config,
  pkgs,
  ...
}: {
  # Audio configuration with PipeWire
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Audio packages
  environment.systemPackages = with pkgs; [
    pavucontrol
    helvum # PipeWire graph editor
  ];
}
