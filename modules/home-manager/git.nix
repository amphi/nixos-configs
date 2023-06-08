{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    gibo
    tig
    vim
  ];

  programs.git = {
    enable = true;
    userName = "Sebastian Eydam";
    userEmail = "sebastian.eydam@cyberus-technology.de";
    extraConfig = {
      core = {
        editor = "vim";
        pager = "cat";
      };
      grep = {
        lineNumber = true;
      };
    };
  };

  home.file.".tigrc".text = ''
    bind main R !git rebase -i %(commit)^
    bind diff R !git rebase -i %(commit)^

    bind main ! !?git revert %(commit)

    set main-view-id = yes
  '';
}
