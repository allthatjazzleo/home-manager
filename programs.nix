{ homeDirectory
, pkgs
, __user }:
let
  programFiles = builtins.filter (file: builtins.match ".*\\.nix" file != null) (builtins.attrNames (builtins.readDir ./programs));
  importProgram = file: import ./programs/${file} { inherit homeDirectory pkgs __user; };
  importedPrograms = builtins.foldl' (acc: attrSet: acc // attrSet) {} (builtins.map (file: importProgram file) programFiles);
in {
  home-manager.enable = true;
  direnv.enable = true;
  git = {
    enable = true;
    userEmail = __user.email;
    userName = __user.github_username;
    # signing = {
    #   key = __user.gitSigningKey;
    #   signByDefault = true;
    # };
    #hooks = { pre-commit = __user.gitPreCommitHook; };

    # set default branch to main
    extraConfig.init.defaultBranch = "main";
  };
} // (importedPrograms)
