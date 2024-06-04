{ lib, pkgs, ... }:
let
  vscodeVersion = pkgs.unstable.vscode.version;
  extensions = (pkgs.forVSCodeVersion vscodeVersion);
  vscode = pkgs.unstable.vscode-with-extensions.override {
    vscode = pkgs.unstable.vscode;
    vscodeExtensions = ([
      # my preferred color and icon theme
      extensions.vscode-marketplace.wesbos.theme-cobalt2
      extensions.vscode-marketplace.pkief.material-icon-theme

      extensions.vscode-marketplace.tamasfe.even-better-toml
      extensions.vscode-marketplace.davidanson.vscode-markdownlint
      extensions.vscode-marketplace.yzhang.markdown-all-in-one
      extensions.vscode-marketplace.zainchen.json
      # extensions.vscode-marketplace.ms-vscode.makefile-tools

      # git
      extensions.vscode-marketplace.waderyan.gitblame

      # nix
      extensions.vscode-marketplace.bbenoist.nix
      extensions.vscode-marketplace.jnoortheen.nix-ide

      # C++
      extensions.vscode-marketplace.twxs.cmake
      #extensions.vscode-marketplace.ms-vscode.cmake-tools
      extensions.vscode-marketplace.llvm-vs-code-extensions.vscode-clangd

      # Python
      extensions.vscode-marketplace.ms-python.python
      extensions.vscode-marketplace.ms-python.vscode-pylance
      extensions.vscode-marketplace.ms-python.autopep8
      extensions.vscode-marketplace.ms-python.black-formatter
      extensions.vscode-marketplace.ms-python.mypy-type-checker
      extensions.vscode-marketplace.ms-python.pylint

      # Rust
      extensions.vscode-marketplace.rust-lang.rust-analyzer

      # Markdown
      extensions.vscode-marketplace.bierner.github-markdown-preview
      extensions.vscode-marketplace.bierner.markdown-mermaid
      extensions.vscode-marketplace.bierner.markdown-emoji
      extensions.vscode-marketplace.bierner.markdown-checkbox
      extensions.vscode-marketplace.bierner.markdown-yaml-preamble
      extensions.vscode-marketplace.bierner.markdown-footnotes
      extensions.vscode-marketplace.bierner.markdown-prism
      extensions.vscode-marketplace.bierner.markdown-preview-github-styles

      # Uiua
      extensions.vscode-marketplace.uiua-lang.uiua-vscode

      # Shell
      extensions.vscode-marketplace.foxundermoon.shell-format
      extensions.vscode-marketplace.timonwong.shellcheck
    ]);
  };
in
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
    package = lib.mkForce vscode;
  };

  home.activation = {
    copySettingsJson = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD rm $VERBOSE_ARG -f $HOME/.config/Code/User/settings.json
      $DRY_RUN_CMD cp ${builtins.toPath ./vscode-settings.json} $HOME/.config/Code/User/settings.json
      $DRY_RUN_CMD chmod +w $HOME/.config/Code/User/settings.json
    '';
  };
}
