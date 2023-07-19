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
}
