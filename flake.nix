{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs@{ nixpkgs, nix-darwin, home-manager, vscode-server, nixvim, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/configuration.nix
          vscode-server.nixosModule
          ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
        ];
      };
    };

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Jonathans-MacBook-Pro
    darwinConfigurations."Jonathans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ ./hosts/mac/configuration.nix ];
      specialArgs = { inherit inputs; };
    };


    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "homeserver@nixos" = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home-manager/homeserver/home.nix ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
      };

      "jonathan" = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home-manager/mac/home.nix nixvim.homeManagerModules.nixvim ];
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
      };
    };
  };
}
