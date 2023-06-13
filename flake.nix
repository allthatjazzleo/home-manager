{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    agenix.url = "github:ryantm/agenix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    std.url = "github:divnix/std";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # Values you should modify
      system = "aarch64-darwin"; # x86_64-linux, aarch64-multiplatform, etc.
      stateVersion =
        "22.11"; # See https://nixos.org/manual/nixpkgs/stable for most recent

      pkgs = import nixpkgs {
        inherit system;

        config = { allowUnfree = true; };
        # Add an overlay to include the package from inputs.std.aarch64-darwin.std.cli.default
        overlays = [
          (self: super: {
            agenix = inputs.agenix.packages.${system}.agenix;
            std = inputs.std.${system}.std.cli.default;
          })
        ];
      };
      users = import ./users.nix; # modify this file to specify your user
      homeDirPrefix =
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";

      f = _: user:
        let
          homeDirectory = "${homeDirPrefix}/${user.username}";
          home = (import ./home.nix {
            inherit homeDirectory pkgs stateVersion system user;
          });
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ inputs.agenix.homeManagerModules.age home ];
          extraSpecialArgs = { inherit user; };
        };
    in { homeConfigurations = builtins.mapAttrs f users; };
}
