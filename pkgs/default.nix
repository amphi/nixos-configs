{ pkgs, pkgs-unstable, nix-vscode-extensions }:
{
  my-vscode = pkgs.callPackage ./vscode.nix { pkgs = pkgs-unstable; inherit nix-vscode-extensions; };
}
