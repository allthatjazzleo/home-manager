{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # Values you should modify
      system = "aarch64-darwin";  # x86_64-linux, aarch64-multiplatform, etc.
      stateVersion = "22.11";     # See https://nixos.org/manual/nixpkgs/stable for most recent

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };
      __user = import ./user.nix; # modify this file to specify your user
      homeDirPrefix = if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      homeDirectory = "${homeDirPrefix}/${__user.username}";

      home = (import ./home.nix {
        inherit homeDirectory pkgs stateVersion system __user;
      });
    in {
      homeConfigurations.${__user.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          home
        ];
      };
    };
}