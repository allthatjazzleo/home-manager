{
  inputs,
  cell,
}: let
  inherit (inputs) agenix sops-nix nixpkgs home-manager;
  inherit (inputs.cells.users) users;
  inherit (cell.home) home;
  f = _: user:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs;
      modules = [agenix.homeManagerModules.age sops-nix.homeManagerModules.sops home];
      extraSpecialArgs = {inherit user;};
    };
in {default = builtins.mapAttrs f users;}
