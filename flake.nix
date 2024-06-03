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
      url = "github:nix-community/nix-vscode-extensions?rev=c1b75aedd50054ff43bb26ddb2702a2ac3475ea2";
      # url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  # https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, nix-vscode-extensions, home-manager, flake-parts }:
    let
      pkgs = import nixpkgs {
        config = { allowUnfree = true; };
        system = "x86_64-linux";
      };
      pkgs-unstable = import nixpkgs-unstable {
        config = { allowUnfree = true; };
        system = "x86_64-linux";
      };
    in
    rec  {

      packages.system.x86_64-linux = import ./pkgs {
        inherit pkgs pkgs-unstable;
        inherit nix-vscode-extensions;
      };

      # Used with `nixos-rebuild build --flake .#<hostname>`.
      nixosConfigurations = {
        xps13-9360 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit (packages.system.x86_64-linux) my-vscode; };
          modules = [
            ./hosts/xps13-9360/configuration.nix
            ./hosts/xps13-9360/hardware-configuration.nix

            nixos-hardware.nixosModules.dell-xps-13-9360

            ./modules/nixos/common.nix
            ./modules/nixos/gnome.nix
            ./modules/nixos/work.nix
            ./modules/nixos/cleanup-profiles.nix
            ./modules/nixos/virtualbox.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.seydam = import ./modules/home-manager;
            }

            {
              # necessary for MS Teams.
              nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
              ];
            }

            {
              services.tailscale = {
                enable = true;
                package = pkgs-unstable.tailscale;
              };
            }
          ];
        };

        boxes-vm = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            specialArgs = { inherit (packages.system.x86_64-linux) my-vscode; };
            modules = [
              ./hosts/boxes-vm/configuration.nix
              ./hosts/boxes-vm/hardware-configuration.nix

              ./modules/nixos/common.nix
              ./modules/nixos/gnome.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.seydam = { config, lib, pkgs, ... }:
                  {
                    home.stateVersion = "23.05";
                    home.username = "seydam";
                    home.homeDirectory = "/home/seydam";

                    programs.home-manager.enable = true;

                    imports = [
                      ./modules/home-manager/vscode.nix
                      ./modules/home-manager/kitty.nix
                    ];
                  };
              }
            ];
          };
      };
    };
}
