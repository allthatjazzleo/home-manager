{ inputs, cell, }:
let inherit (inputs) nixpkgs;
in {
  default = homeDirectory: user:
    let
      programFiles =
        builtins.filter (file: builtins.match ".*\\.nix" file != null)
        (builtins.attrNames (builtins.readDir ./programs));
      importProgram = file:
        import ./programs/${file} { inherit inputs cell homeDirectory user; };
      importedPrograms = builtins.foldl' (acc: attrSet: acc // attrSet) { }
        (builtins.map (file: importProgram file) programFiles);
    in {
      home-manager.enable = true;
      direnv.enable = true;
      git = {
        enable = true;
        userEmail = user.email;
        userName = user.github_username;
        # signing = {
        #   key = user.gitSigningKey;
        #   signByDefault = true;
        # };
        #hooks = { pre-commit = user.gitPreCommitHook; };

        # set default branch to main
        extraConfig.init.defaultBranch = "main";
        ignores = [ ".DS_Store" ];
      };
    } // (importedPrograms);
}
