{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  default = homeDirectory: user: let
    programFiles =
      builtins.filter (file: builtins.match ".*\\.nix" file != null)
      (builtins.attrNames (builtins.readDir ./programs));
    importProgram = file:
      import ./programs/${file} {inherit inputs cell homeDirectory user;};
    importedPrograms =
      builtins.foldl' (acc: attrSet: acc // attrSet) {}
      (builtins.map (file: importProgram file) programFiles);
  in
    {
      home-manager.enable = true;
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      delta = {
        enable = true;
        options = {
          features = "decorations";
          whitespace-error-style = "22 reverse";
          line-numbers = true;
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-style = "bold yellow ul";
            file-decoration-style = "none";
          };
        };
      };
      git = {
        enable = true;
        settings = {
          user = {
            name = user.github_username;
            email = user.email;
          };
          # set default branch to main
          init.defaultBranch = "main";
        };
        lfs = {
          enable = true;
        };
        signing = {
          key =
            if builtins.hasAttr "gitSigningKey" user
            then user.gitSigningKey
            else null;
          signByDefault =
            if builtins.hasAttr "gitSigningKey" user
            then true
            else false;
        };
        #hooks = { pre-commit = user.gitPreCommitHook; };

        ignores = [".DS_Store"];
      };
    }
    // importedPrograms;
}
