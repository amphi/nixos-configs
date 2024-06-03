{ config, lib, ... }:
let
  cfg = config.vbox;
in
{
  options.vbox = {
    enable = lib.mkEnableOption "Enable Vitual Box.";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
      addNetworkInterface = false;
    };

    users.extraGroups.vboxusers.members = [ "seydam" ];
  };
}
