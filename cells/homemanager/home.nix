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
    getPkgOutPath = {
      pkgs,
      name,
      dev ? null,
    }: let
      pkg = builtins.head (builtins.filter (pkg: builtins.match (".*" + name + ".*") pkg.name != null) pkgs);
    in
      if pkg == null
      then ""
      else if dev == null
      then pkg.outPath
      else pkg.dev.outPath;
  in {
    home = {
      inherit homeDirectory packages;
      username = user.username;
      stateVersion = "23.05"; # See https://nixos.org/manual/nixpkgs/stable for most recent version
      sessionVariables = {
        # DAML_HOME = getPkgOutPath {
        #   pkgs = packages;
        #   name = "daml-sdk";
        # };
        PKG_CONFIG_PATH = "${(getPkgOutPath {
          pkgs = packages;
          name = "openssl";
          dev = "dev";
        })}/lib/pkgconfig";
      };
      shellAliases = {update = "home-manager switch";};

      file.".config/nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          allowUnsupportedSystem = true;
        }
      '';

      file.".config/fzf-git.sh".text = builtins.readFile (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/junegunn/fzf-git.sh/master/fzf-git.sh";
        sha256 = "10h7lhf99jdmzwxl0v0qvild0cr0cx5kv8kanni8w1v1vbh47pjd";
      });
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
