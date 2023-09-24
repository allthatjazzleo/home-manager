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
    # nixpkgs.jdk17 should enable enableJavaFX
    package = nixpkgs.jdk17.overrideAttrs (oldAttrs: {enableJavaFX = true;});
  };
}
