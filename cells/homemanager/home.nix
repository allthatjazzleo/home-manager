{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  nixTools = cell.packages.nixTools;
in {
  home = {
    config,
    user,
    options,
    ...
  }: let
    homeDirPrefix =
      if nixpkgs.stdenv.hostPlatform.isDarwin
      then "/Users"
      else "/home";
    homeDirectory = "${homeDirPrefix}/${user.username}";
    packages = nixTools user;
    userAgeIdentityPaths =
      if builtins.hasAttr "ageIdentityPaths" user
      then
        map (path: builtins.replaceStrings ["~"] [homeDirectory] path)
        user.ageIdentityPaths
      else [];
    sopsAgeKeyPath =
      if nixpkgs.stdenv.hostPlatform.isDarwin
      then "${homeDirectory}/Library/Application Support/sops/age/keys.txt"
      else "${homeDirectory}/.config/sops/age/keys.txt";
    getPkgOutPath = pkgs: name: let
      pkg = builtins.filter (pkg: builtins.match (".*" + name + ".*") pkg.name != null) pkgs;
    in
      if pkg == []
      then ""
      else (builtins.head pkg).outPath;
  in {
    home = {
      inherit homeDirectory packages;
      username = user.username;
      stateVersion = "23.05"; # See https://nixos.org/manual/nixpkgs/stable for most recent version
      sessionVariables = {DAML_HOME = getPkgOutPath packages "daml-sdk";};
      shellAliases = {update = "home-manager switch";};

      file.".config/nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          allowUnsupportedSystem = true;
        }
      '';
    };

    programs = cell.programs.default homeDirectory user;

    age.identityPaths =
      options.age.identityPaths.default
      ++ userAgeIdentityPaths;
    age.secrets.ssh-config = {
      file = ./secrets/ssh-config.age;
      path = "${homeDirectory}/.ssh/config";
    };
    age.secrets.nix-config = {
      file = ./secrets/nix.conf.age;
      path = "${homeDirectory}/.config/nix/nix.conf";
    };
    age.secrets.sops-age-key = {
      file = ./secrets/sops-age-key.age;
      path = sopsAgeKeyPath;
    };

    sops = {
      age.keyFile = config.age.secrets.sops-age-key.path;
      defaultSopsFile = ./secrets/secrets.yaml;
      secrets.mysecret = {
        path = "${homeDirectory}/.config/mysecret";
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        allowUnsupportedSystem = true;
      };
    };
  };
}
