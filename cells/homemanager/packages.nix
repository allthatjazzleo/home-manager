{ inputs, cell, }:
let inherit (inputs) nixpkgs;
in {
  nixTools = user:
    let
      userPackages =
        if builtins.hasAttr "packages" user then user.packages nixpkgs else [ ];
    in with nixpkgs;
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
    ] ++ userPackages;
}
