{
  inputs,
  cell,
}: let
  inherit (inputs) agenix sops-nix mac-app-util nixpkgs home-manager;
  inherit (inputs.cells.users) users;
  inherit (cell.home) home;
  baseModules = [agenix.homeManagerModules.age sops-nix.homeManagerModules.sops home];
  darwinModules =
    if nixpkgs.stdenv.hostPlatform.isDarwin
    then [mac-app-util.homeManagerModules.default]
    else [];
  f = _: user:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs;
      modules = baseModules ++ darwinModules;
      extraSpecialArgs = {inherit user;};
    };
in {default = builtins.mapAttrs f users;}
