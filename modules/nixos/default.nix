{
  cleanup-profiles = import ./cleanup-profiles.nix;
  common = import ./common.nix;
  desktop = import ./desktop.nix;
  gnome = import ./gnome.nix;
  virtualbox = import ./virtualbox.nix;
  work = import ./work.nix;
}
