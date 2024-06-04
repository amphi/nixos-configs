# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixosModules, lib, ... }:

{
  imports = with nixosModules; [
    cleanup-profiles
    common
    desktop
    gnome
    virtualbox
    work
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-b02e2325-4eb4-4998-97df-171a798fe43c".device = "/dev/disk/by-uuid/b02e2325-4eb4-4998-97df-171a798fe43c";
  boot.initrd.luks.devices."luks-b02e2325-4eb4-4998-97df-171a798fe43c".keyFile = "/crypto_keyfile.bin";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.utf8";
    LC_IDENTIFICATION = "de_DE.utf8";
    LC_MEASUREMENT = "de_DE.utf8";
    LC_MONETARY = "de_DE.utf8";
    LC_NAME = "de_DE.utf8";
    LC_NUMERIC = "de_DE.utf8";
    LC_PAPER = "de_DE.utf8";
    LC_TELEPHONE = "de_DE.utf8";
    LC_TIME = "de_DE.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.seydam = {
    isNormalUser = true;
    description = "seydam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [
      # my-vscode
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    trace-cmd
    linuxPackages_latest.perf
  ];

  vbox.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # systemd.network.links."39-testNic" = {
  #   matchConfig.PermanentMACAddress = "00:0a:cd:26:04:17";
  #   linkConfig.Name = "testNic";
  # };

  services.udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", \
    ATTR{address}=="00:0a:cd:26:04:17", KERNEL=="eth*", NAME="testNic"
  '';

  networking = {
    hostName = "seydam-xps13";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      #   allowedTCPPorts = [ 53 67 68 69 80 443 6969 7000 8000 8080 8081 9000 ];
      #   allowedUDPPorts = [ 53 67 68 69 80 443 6969 7000 8000 8080 8081 9000 ];
    };
    # interfaces = {
    #   "testNic".ipv4.addresses = [{
    #     address = "192.168.35.1";
    #     prefixLength = 24;
    #   }];
    #   "tap0" = {
    #     ipv4.addresses = [{
    #       address = "192.168.33.1";
    #       prefixLength = 24;
    #     }];
    #     virtual = true;
    #     virtualType = "tap";
    #   };
    #   "tap1" = {
    #     ipv4.addresses = [{
    #       address = "192.168.34.1";
    #       prefixLength = 24;
    #     }];
    #     virtual = true;
    #     virtualType = "tap";
    #   };
    # };
  };

  # services.dnsmasq = {
  #   enable = true;
  #   resolveLocalQueries = false;
  #   settings = {
  #     interface = [ "tap0" "tap1" "testNic" ];
  #     # interface = [ "tap0" "tap1" ];
  #     bind-interfaces = true;
  #     dhcp-authoritative = true;

  #     enable-tftp = true;
  #     tftp-root = "/var/lib/tftpboot/";

  #     log-queries = true;
  #     log-debug = true;
  #     log-dhcp = true;
  #     log-facility = "/var/log/dnsmasq.log";
  #     listen-address = [ "192.168.33.1" "192.168.34.1" "192.168.35.1" ];
  #     # no-resolv = true;
  #     dhcp-option = [
  #       3
  #     ];
  #     dhcp-range = [
  #       "tap0,192.168.33.2,192.168.33.2,infinite"
  #       "tap1,192.168.34.2,192.168.34.2,infinite"
  #       "testNic,192.168.35.100,192.168.35.110,infinite"
  #     ];
  #     dhcp-host = [
  #       "08:00:27:c9:dc:e3,vm0,192.168.33.2"
  #       "08:00:27:c9:dc:e4,vm1,192.168.34.2"
  #     ];
  #     dhcp-match = [
  #       "x86PC, option:client-arch, 0" #BIOS x86
  #       "BC_EFI, option:client-arch, 7" #EFI x86-64
  #     ];
  #     dhcp-boot = [
  #       "tag:x86PC,ipxe.kpxe"
  #       "tag:BC_EFI,snponly.efi"
  #     ];
  #   };
  # };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "localhost" = {
        listen = [
          { addr = "localhost"; port = 8081; }
        ];
        locations."/" = {
          extraConfig = ''
            resolver 100.100.100.100 valid=30s ipv6=off;
            set $artifacts artifact.vpn.cyberus-technology.de;
            proxy_pass https://$artifacts;
          '';
        };
      };
    };
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.flags = [ "--recreate-lock-file" ];
  system.autoUpgrade.flake = "/home/seydam/Documents/nixos-configs/.#xps13-9360";
  system.autoUpgrade.dates = "12:00";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
