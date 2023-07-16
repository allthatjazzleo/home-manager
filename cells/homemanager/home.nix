{ inputs, cell, }:
let
  inherit (inputs) nixpkgs;
  nixTools = cell.packages.nixTools;
in {
  home = { config, user, options, ... }:
    let
      homeDirPrefix =
        if nixpkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      homeDirectory = "${homeDirPrefix}/${user.username}";
      packages = (nixTools user);
      userAgeIdentityPaths = if builtins.hasAttr "ageIdentityPaths" user then
        map (path: builtins.replaceStrings [ "~" ] [ homeDirectory ] path)
        user.ageIdentityPaths
      else
        [ ];
    in {
      home = {
        inherit homeDirectory packages;
        username = user.username;
        stateVersion =
          "23.05"; # See https://nixos.org/manual/nixpkgs/stable for most recent version
        shellAliases = {
          update = "home-manager switch --impure";
        }; # --impure is required for builtins.currentSystem in flake

        file.".config/nixpkgs/config.nix".text = ''
          { 
            allowUnfree = true; 
            allowUnfreePredicate = (_: true);
            allowUnsupportedSystem = true;
          }
        '';
      };

      programs = (cell.programs.default homeDirectory user);

      age.identityPaths = options.age.identityPaths.default
        ++ userAgeIdentityPaths;
      age.secrets.ssh-config = {
        file = ./secrets/ssh-config.age;
        path = "${homeDirectory}/.ssh/config";
      };
      age.secrets.nix-config = {
        file = ./secrets/nix.conf.age;
        path = "${homeDirectory}/.config/nix/nix.conf";
      };

      nixpkgs = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          allowUnsupportedSystem = true;
        };
      };
    };
}
