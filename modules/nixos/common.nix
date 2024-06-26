{ config, pkgs, overlays, ... }:
let
  my-python-packages = ps: with ps; [
    pip
    pylint
    requests
    urllib3
  ];
in
{
  environment.systemPackages = with pkgs; [
    magic-wormhole
    git
    cachix
    curl
    dig
    file
    pciutils
    wget
    zip
    toybox
    tldr
    niv
    element-desktop
    usbutils
    tree

    (python3.withPackages my-python-packages)
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "seydam" ];
  };

  nixpkgs = {
    inherit overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  services = {
    fwupd.enable = true;
    cron.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  virtualisation.docker.enable = true;

  users = {
    users."seydam" = {
      createHome = true;
      isNormalUser = true;
      extraGroups = [
        "dialout"
        "docker"
        "lp"
        "scanner"
        "sound"
        "tty"
        "networkmanager"
        "wheel"
      ];
      shell = "${pkgs.zsh}/bin/zsh";
      initialPassword = "1234";
      packages = [ ];
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];
}
