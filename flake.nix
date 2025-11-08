{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    nixago = {
      url = "github:nix-community/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:divnix/std";
      inputs.devshell.follows = "devshell";
      inputs.nixago.follows = "nixago";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    std,
    self,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;

      cellsFrom = ./cells;

      cellBlocks = with std.blockTypes; [
        (devshells "devshells")
        (data "users")
        (functions "configurations")
        (functions "packages")
        (functions "programs")
        (functions "home")
        (nixago "configs")
      ];

      nixpkgsConfig = {
        # Nixpkgs configuration applied to inputs.nixpkgs
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        allowUnsupportedSystem = true;
      };
    }
    {
      devShells = std.harvest self ["_automation" "devshells"];
      homeConfigurations =
        (std.pick self ["homemanager" "configurations"]).default;
    };
}
