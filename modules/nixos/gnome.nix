{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    google-chrome

    gnome.dconf-editor
    gnome.gnome-boxes
    gnome.gnome-calculator
    gnome.gnome-disk-utility
    gnome.gnome-system-monitor
    gnome.gnome-tweaks
    gnome.nautilus

    virt-manager

    gparted
    okular

    dconf2nix

    # my current note taking app
    obsidian
  ];

  fonts = {
    fontDir.enable = true;

    enableDefaultFonts = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      corefonts
      freefont_ttf
      liberation_ttf
      nerdfonts
      roboto
    ];

    fontconfig = {
      defaultFonts = { monospace = [ "Source Code Pro" ]; };
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";

    qemu.swtpm.enable = true;

    qemu.ovmf.enable = true;
    qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
  };

  # USB Passthrough.
  virtualisation.spiceUSBRedirection.enable = true;

  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
      hplipWithPlugin
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
    ];
  };

  # Enable sound.
  sound.enable = true;

  security.rtkit.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.xserver.enable = true;
  services.xserver.xkbOptions = "ctrl:nocaps";

  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = config.hardware.trackpoint.enable;
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false;
}
