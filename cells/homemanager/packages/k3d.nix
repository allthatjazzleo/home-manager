{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in
  nixpkgs.k3d.overrideAttrs (old: rec {
    version = "5.5.2";
    k3sVersion = "1.27.4-k3s1";
    src = nixpkgs.fetchFromGitHub {
      owner = "k3d-io";
      repo = "k3d";
      rev = "v${version}";
      sha256 = "sha256-Pa2kqeVl+TEsHOpnE7+iG3feYVAuYrDYnWyDpWJay7M=";
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
