{
  inputs,
  cell,
  user,
  ...
}: let
  inherit (inputs) nixpkgs;
in {
  java = {
    enable = user.java or false;
    package = nixpkgs.jdk17;
  };
}
