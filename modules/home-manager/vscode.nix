{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nixpkgs-fmt
    nil

    # needed for clangd
    clang-tools

    shellcheck
    shfmt

    black # black formatter
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  home.activation = {
    copySettingsJson = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD rm $VERBOSE_ARG -f $HOME/.config/Code/User/settings.json
      $DRY_RUN_CMD cp ${builtins.toPath ./vscode-settings.json} $HOME/.config/Code/User/settings.json
      $DRY_RUN_CMD chmod +w $HOME/.config/Code/User/settings.json
    '';
  };
}
