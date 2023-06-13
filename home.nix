{ homeDirectory, pkgs, stateVersion, system, user }:

let packages = import ./packages.nix { inherit pkgs; };
in {
  age.secrets.ssh-config = {
    file = ./secrets/ssh-config.age;
    path = "${homeDirectory}/.ssh/config";
  };

  home = {
    inherit homeDirectory packages stateVersion;
    username = user.username;
    shellAliases = { update = "home-manager switch"; };
  };

  nixpkgs = {
    config = {
      inherit system;
      allowUnfree = true;
      allowUnsupportedSystem = true;
      experimental-features = "nix-command flakes";
    };
  };

  programs = import ./programs.nix { inherit homeDirectory pkgs user; };
}
