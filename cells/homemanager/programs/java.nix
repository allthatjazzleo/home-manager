{
  inputs,
  cell,
  user,
  ...
}: let
  inherit (inputs) nixpkgs;
  jdk17 = nixpkgs.jdk17.override {enableJavaFX = true;};
in {
  java = {
    enable = user.java or false;
    # nixpkgs.jdk17 should enable enableJavaFX
    package = jdk17;
  };
}
