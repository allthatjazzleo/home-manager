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
    # k3d = import ./packages/k3d.nix {inherit inputs cell;};
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
        (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
        gopls
        helmfile
        htop
        inetutils
        just
        k3d
        kubectl
        kubectx
        (wrapHelm kubernetes-helm {plugins = [kubernetes-helmPlugins.helm-secrets kubernetes-helmPlugins.helm-diff];})
        kustomize
        lorri
        nixfmt
        nodejs-18_x
        operator-sdk
        poetry
        rustup
        shellcheck
        smartmontools
        starship
        terraform
        tmux
        tree
        yarn
        yq-go
        zsh-autosuggestions
        zsh-syntax-highlighting

        # from inputs
        inputs.agenix.packages.agenix
        inputs.std.std.cli.std
      ]
      ++ userPackages;
}
