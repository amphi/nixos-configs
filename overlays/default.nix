{ nix-vscode-extensions, nixpkgs-unstable }:
# will be transformed to a list with builtins.attrValues later
{
  nixpkgs-unstable = final: prev: { unstable = import nixpkgs-unstable { inherit (prev) config system; }; };
  nix-vscode-overlay = nix-vscode-extensions.overlays.default;
}
