{
  description = "My NixOS configurations";

  nixConfig.experimental-features = [ "nix-command" "flakes" ];

  # https://nixos.wiki/wiki/Flakes#Input_schema
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # https://github.com/nix-community/nix-vscode-extensions
    nix-vscode-extensions = {
      # Need at least vs code version >= 1.82 to use upstream extensions.
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, nix-vscode-extensions, home-manager }:
  rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit nixpkgs-unstable nix-vscode-extensions; };

      nixosConfigurations = {
        xps13-9360 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit nixosModules;
            overlays = builtins.attrValues overlays;
          };

          modules = [
            ./hosts/xps13-9360/configuration.nix
            ./hosts/xps13-9360/hardware-configuration.nix

            nixos-hardware.nixosModules.dell-xps-13-9360

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.seydam = import ./hosts/xps13-9360/home-configuration.nix;
              home-manager.extraSpecialArgs = {
                inherit homeManagerModules;
                overlays = builtins.attrvalues overlays;
              };
            }

            {
              # necessary for MS Teams.
              nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
              ];
            }
          ];
        };
      };
    };
}
