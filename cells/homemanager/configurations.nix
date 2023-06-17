{ inputs, cell, }:
let
  inherit (inputs) agenix nixpkgs home-manager;
  inherit (inputs.cells.users) users;
  inherit (cell.home) home;
  age = agenix.homeManagerModules.age;
  f = _: user:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs;
      modules = [ age home ];
      extraSpecialArgs = { inherit user; };
    };
in { default = builtins.mapAttrs f users; }
