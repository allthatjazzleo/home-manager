{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    agenix.url = "github:ryantm/agenix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
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
        #
        (functions "configurations")
        (functions "modules")
        (functions "packages")
        (functions "programs")
        (functions "home")
        (data "users")
      ];
    }

    {
      homeConfigurations =
        (std.pick self [ "homemanager" "configurations" ]).default;
    };
}
