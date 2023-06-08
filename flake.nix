{
  description = "My NixOS configurations";

  # https://nixos.wiki/wiki/Flakes#Input_schema
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # https://github.com/nix-community/nix-vscode-extensions
    nix-vscode-extensions = {
      # Need at least vs code version >= 1.82 to use upstream extensions. 
      # url = "github:nix-community/nix-vscode-extensions?rev=9a1e130619ec0b2e16624aef973f6437029e2d17";
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TUXEDO Control Center written in Rust.
    tuxedo-rs = {
      url = "github:AaronErhardt/tuxedo-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, nix-vscode-extensions, home-manager, tuxedo-rs }@inputs:
    rec  {

      packages.system.x86_64-linux = import ./pkgs {
        pkgs = import nixpkgs {
          config = { allowUnfree = true; };
          system = "x86_64-linux";
        };
        pkgs-unstable = import nixpkgs-unstable {
          config = { allowUnfree = true; };
          system = "x86_64-linux";
        };
        inherit nix-vscode-extensions;
      };

      # Used with `nixos-rebuild build --flake .#<hostname>`.
      nixosConfigurations = {
        xp14gen12 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit (packages.system.x86_64-linux) my-vscode; };
          modules = [
            ./hosts/xp14gen12/configuration.nix
            ./hosts/xp14gen12/hardware-configuration.nix

            tuxedo-rs.nixosModules.default

            ./modules/nixos/common.nix
            ./modules/nixos/gnome.nix
            ./modules/nixos/work.nix
            ./modules/nixos/cleanup-profiles.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.seydam = { config, lib, pkgs, ... }:
                {
                  home.stateVersion = "22.05";
                  home.username = "seydam";
                  home.homeDirectory = "/home/seydam";

                  programs.home-manager.enable = true;

                  imports = [
                    ./modules/home-manager/git.nix
                    ./modules/home-manager/gnome.nix
                    ./modules/home-manager/kitty.nix
                    ./modules/home-manager/vscode.nix
                  ];
                };
            }
          ];
        };

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

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.seydam = { config, lib, pkgs, ... }:
                {
                  home.stateVersion = "22.05";
                  home.username = "seydam";
                  home.homeDirectory = "/home/seydam";

                  programs.home-manager.enable = true;

                  imports = [
                    ./modules/home-manager/git.nix
                    ./modules/home-manager/gnome.nix
                    ./modules/home-manager/kitty.nix
                    ./modules/home-manager/vscode.nix
                  ];
                };
            }
          ];
        };

        boxes-vm = nixpkgs.lib.nixosSystem {
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
