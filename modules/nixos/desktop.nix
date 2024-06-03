{ config, lib, pkgs, ... }:
let
  cfg = config.nixos-modules.desktop;
in
{
  options.nixos-modules.desktop.enable = lib.mkEnableOption "Enable Gnome Desktop";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome.dconf-editor
      gnome.gnome-boxes
      gnome.gnome-calculator
      gnome.gnome-disk-utility
      gnome.gnome-system-monitor
      gnome.gnome-tweaks
      gnome.nautilus

      gparted
      okular

      dconf2nix
    ];

    services.xserver.enable = true;
    services.xserver.xkbOptions = "ctrl:nocaps";

    hardware.trackpoint.enable = true;
    hardware.trackpoint.emulateWheel = config.hardware.trackpoint.enable;
    services.xserver.libinput.enable = true;

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.gnome.core-utilities.enable = false;
  };
}
