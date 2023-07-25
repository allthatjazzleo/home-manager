{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in
  nixpkgs.k3d.overrideAttrs (old: rec {
    version = "5.5.1";
    k3sVersion = "v1.21.7-k3s1";
    src = nixpkgs.fetchFromGitHub {
      owner = "k3d-io";
      repo = "k3d";
      rev = "v${version}";
      sha256 = "sha256-cXUuWR5ALgCgr1bK/Qpdpo978p3PRL3/H6j1T7DKrT4=";
    };
    ldflags = let
      t = "github.com/k3d-io/k3d/v${nixpkgs.lib.versions.major version}/version";
    in
      ["-s" "-w" "-X ${t}.Version=v${version}"] ++ nixpkgs.lib.optionals true ["-X ${t}.K3sVersion=v${k3sVersion}"];
    preBuild = ''
      export GOWORK=off
    '';
    installCheckPhase = "";
  })
