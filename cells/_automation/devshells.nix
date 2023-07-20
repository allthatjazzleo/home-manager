{
  inputs,
  cell,
}: let
  inherit (inputs.std) lib std;
in {
  # Tool Homepage: https://numtide.github.io/devshell/
  default = lib.dev.mkShell {
    name = "homemanager devshell";

    # Tool Homepage: https://nix-community.github.io/nixago/
    # This is Standard's devshell integration.
    # It runs the startup hook when entering the shell.
    nixago = [
      ((lib.dev.mkNixago lib.cfg.treefmt) cell.configs.treefmt)
      ((lib.dev.mkNixago lib.cfg.lefthook) cell.configs.lefthook)
    ];

    imports = [std.devshellProfiles.default];

    commands = [
      {
        name = "fmt";
        command = "treefmt";
        help = "Formats nix files";
        category = "Development";
      }
      {
        name = "fmt-ci";
        command = "treefmt --fail-on-change";
        help = "Formats nix files";
        category = "Development";
      }
    ];
  };
}
