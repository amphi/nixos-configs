{ pkgs, ... }:
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
    bind diff ! !?git revert %(commit)

    bind main = !git commit --fixup=%(commit)
    bind diff = !git commit --fixup=%(commit)

    bind main <Ctrl-R> !git rebase --autosquash -i %(commit)^
    bind diff <Ctrl-R> !git rebase --autosquash -i %(commit)^

    set main-view-id = yes
  '';
}
