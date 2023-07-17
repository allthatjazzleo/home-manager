{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:divnix/std";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { std, self, ... }@inputs:
    std.growOn {
      inherit inputs;

      cellsFrom = ./cells;

      cellBlocks = with std.blockTypes; [
        (functions "configurations")
        (functions "modules")
        (functions "packages")
        (functions "programs")
        (functions "home")
        (data "users")
      ];

      nixpkgsConfig = {
        # Nixpkgs configuration applied to inputs.nixpkgs
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
        allowUnsupportedSystem = true;
      };
    }

    {
      homeConfigurations =
        (std.pick self [ "homemanager" "configurations" ]).default;
    };
}
