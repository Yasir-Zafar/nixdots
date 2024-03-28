{ pkgs, ... }:{
  
services = {
	# Ensure gnome-settings-daemon udev rules are enabled.
	udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
	xserver = {
		# Required for DE to launch.
		enable = true;
		displayManager = {
			gdm = {
				enable = true;
				wayland = true;
			};
		};
		# Enable Desktop Environment.
		desktopManager.gnome.enable = true;
		# Exclude default X11 packages I don't want.
		excludePackages = with pkgs; [ xterm ];
	};
};

environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  cheese # webcam tool
  gnome-music
  gnome-terminal
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
]);

services.xserver.displayManager.autoLogin.enable = true;
services.xserver.displayManager.autoLogin.user = "account";
}
