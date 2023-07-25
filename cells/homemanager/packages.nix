{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  nixTools = user: let
    userPackages =
      if builtins.hasAttr "packages" user
      then user.packages nixpkgs
      else [];
    k3d = nixpkgs.k3d.overrideAttrs (old: rec {
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
    });
  in
    with nixpkgs;
      [
        ansible
        awscli2
        cachix
        delve
        direnv
        dive
        gh
        git-open
        gnupg
        go
        go-tools
        gopls
        helmfile
        htop
        inetutils
        just
        k3d
        kubectl
        kubectx
        kubernetes-helm
        kustomize
        lorri
        nixfmt
        nodejs-18_x
        rustup
        shellcheck
        starship
        terraform
        tmux
        tree
        yarn
        zsh-autosuggestions
        zsh-syntax-highlighting

        # from inputs
        inputs.agenix.packages.agenix
        inputs.std.std.cli.std
      ]
      ++ userPackages;
}
