{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /* Used for Niri */
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    /* Noctalia shell (Wayland desktop shell + launcher) */
    # noctalia.url = "github:noctalia-dev/noctalia-shell";
    # noctalia.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/laptop/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
						extraSpecialArgs = { inherit inputs; };
            users.magoa = import ./home/magoa/default.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
