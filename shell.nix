{ pkgs ? import <nixpkgs> { } }:
let
  myNeovim = pkgs.neovim.override {
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          vim-nix
        ];
      };
    };
  };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    myNeovim
    nixpkgs-fmt
  ];
}
