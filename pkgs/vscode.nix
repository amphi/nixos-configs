{ pkgs, nix-vscode-extensions }:
let
  extensions = nix-vscode-extensions.extensions.x86_64-linux;
in
pkgs.vscode-with-extensions.override {
  vscode = pkgs.vscode;
  vscodeExtensions = ([
    # my preferred color and icon theme
    extensions.vscode-marketplace.wesbos.theme-cobalt2
    extensions.vscode-marketplace.pkief.material-icon-theme

    extensions.vscode-marketplace.tamasfe.even-better-toml
    extensions.vscode-marketplace.davidanson.vscode-markdownlint
    extensions.vscode-marketplace.yzhang.markdown-all-in-one
    extensions.vscode-marketplace.zainchen.json
    extensions.vscode-marketplace.ms-vscode.makefile-tools

    # git
    extensions.vscode-marketplace.waderyan.gitblame

    # nix
    extensions.vscode-marketplace.bbenoist.nix
    extensions.vscode-marketplace.jnoortheen.nix-ide

    # C++
    extensions.vscode-marketplace.twxs.cmake
    extensions.vscode-marketplace.ms-vscode.cmake-tools
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
  ]);
}
