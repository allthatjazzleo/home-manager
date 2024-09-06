{
  inputs,
  cell,
}: {
  # Tool Homepage: https://numtide.github.io/treefmt/
  treefmt = {
    packages = [
      inputs.nixpkgs.alejandra
    ];
    data = {
      formatter = {
        nix = {
          command = "alejandra";
          includes = ["*.nix"];
        };
      };
    };
    hook.mode = "copy";
  };

  lefthook = {
    data = {
      pre-commit = {
        commands = {
          fmt = {
            run = ''
              FILES=$(git diff --cached --name-only --diff-filter=ACMR | sed 's| |\\ |g')
              [ -z "$FILES" ] && exit 0

              fmt-ci 2>&1 | sed 's/\x1b\[[0-9;]*m//g'; fmt_ci_status="${PIPESTATUS [0]}";
              [[ $fmt_ci_status -eq 0 ]] && exit 0

              echo "Please add treefmt formatted file(s)!" && exit 1
            '';
          };
        };
      };
    };
  };

  sops = {
    commands = [{package = inputs.nixpkgs.sops;}];
    data = {
      creation_rules = [
        {
          path_regex = "cells/homemanager/secrets/secrets.*\\.yaml$";
          key_groups = [
            {
              age = ["age16xsy2zm683378v6w54lmghqup7tpkc862jmwff6vavdvusdlnyasu239cj"];
            }
          ];
        }
      ];
      keys = ["age16xsy2zm683378v6w54lmghqup7tpkc862jmwff6vavdvusdlnyasu239cj"];
    };
    format = "yaml";
    output = ".sops.yaml";
  };
}
