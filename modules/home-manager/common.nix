{ ... }:
{
  programs.home-manager.enable = true;

  home.username = "seydam";
  home.homeDirectory = "/home/seydam";

  # Determines the home manager release this configuration is compatible with.
  home.stateVersion = "23.11";
}
