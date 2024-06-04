{ ... }:
{
  # Tailscale.
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  systemd.network.wait-online.extraArgs = [ "--ignore=tailscale0" ];

  # Cyberus binary cache and remote builder.
  nix = {
    settings = {
      trusted-public-keys = [
        "cyberus-1:0jjMD2b+guloGW27ZToxDQApCoWj+4ONW9v8VH/Bv0Q="
      ];
      trusted-substituters = [
        "http://binary-cache-v2.vpn.cyberus-technology.de"
      ];
    };
    extraOptions = ''
      builders-use-substitutes = true
      # See https://discourse.nixos.org/t/precedence-with-multiple-substituters/1191 for a discussion about priorities.
      extra-substituters = http://binary-cache-v2.vpn.cyberus-technology.de
    '';
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "remote-builder.vpn.cyberus-technology.de";
        system = "x86_64-linux";
        systems = [ "x86_64-linux" "aarch64-linux" ];
        maxJobs = 100;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        sshUser = "builder";
      }
    ];
  };

  programs.ssh.extraConfig = ''
    Host remote-builder.vpn.cyberus-technology.de
      IdentityFile = /home/seydam/.ssh/id_rsa
  '';

  programs.ssh.knownHosts = {
    nixBuild = {
      hostNames = [ "remote-builder.vpn.cyberus-technology.de" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwdIPCDHFhao84ZoHgphp+hzYH9ot+L2gSDFD8HrMyw";
    };
  };
}
