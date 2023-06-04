{ homeDirectory
, pkgs
, stateVersion
, system
, __user }:

let
  packages = import ./packages.nix { inherit pkgs; };
in {
  home = {
    inherit homeDirectory packages stateVersion;
    username = __user.username;
    shellAliases = {
      update = "home-manager switch";
    };
  };

  nixpkgs = {
    config = {
      inherit system;
      allowUnfree = true;
      allowUnsupportedSystem = true;
      experimental-features = "nix-command flakes";
    };
  };

  programs = import ./programs.nix { inherit homeDirectory pkgs __user; };
}