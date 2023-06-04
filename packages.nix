{ pkgs }:

let
  nixTools = with pkgs; [
    ansible
    awscli2
    cachix
    cargo
    direnv
    gh
    git-open
    gnupg
    go
    helmfile
    inetutils
    kubectl
    kubernetes-helm
    lorri
    nixfmt
    nodejs-18_x
    rustc
    terraform
    tmux
    tree
    yarn
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
in nixTools