{ ... }:
{
  programs.home-manager.enable = true;

  home.username = "seydam";
  home.homeDirectory = "/home/seydam";

  imports = [
    ./git.nix
    ./gnome.nix
    ./kitty.nix
    ./vscode.nix
  ];

  # Determines the home manager release this configuration is compatible with.
  home.stateVersion = "23.11";
}
