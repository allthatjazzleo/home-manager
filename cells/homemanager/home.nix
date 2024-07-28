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
      stateVersion = "24.05"; # See https://nixos.org/manual/nixpkgs/stable for most recent version
      sessionVariables = {
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
        sha256 = "00n22b86lr02pgipadnv7rmqklrcdz3pydc7py8zjffzzdwa24ia";
      });
    };

    programs = cell.programs.default homeDirectory user;

    age.identityPaths = userAgeIdentityPaths;

    # don't create age and sops secrets if no age key identity paths are provided to avoid errors
    age.secrets =
      if builtins.length config.age.identityPaths > 0
      then {
        ssh-config = {
          file = ./secrets/ssh-config.age;
          path = "${homeDirectory}/.ssh/config";
        };
        nix-config = {
          file = ./secrets/nix.conf.age;
          path = "${homeDirectory}/.config/nix/nix.conf";
        };
        sops-age-key = {
          file = ./secrets/sops-age-key.age;
          path = sopsAgeKeyPath;
        };
      }
      else {};

    sops =
      if builtins.length config.age.identityPaths > 0
      then {
        age.keyFile = config.age.secrets.sops-age-key.path;
        defaultSopsFile = ./secrets/secrets.yaml;
        secrets.mysecret = {
          path = "${homeDirectory}/.config/mysecret";
        };
      }
      else {};

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        allowUnsupportedSystem = true;
      };
    };
  };
}
