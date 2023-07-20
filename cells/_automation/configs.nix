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

              fmt-ci && exit 0
              echo "Please add treefmt formatted file(s)!" && exit 1
            '';
          };
        };
      };
    };
  };
}
