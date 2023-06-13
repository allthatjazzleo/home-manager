{ pkgs }:

let
  nixTools = with pkgs; [
    agenix
    ansible
    awscli2
    cachix
    direnv
    gh
    git-open
    gnupg
    go
    helmfile
    inetutils
    kubectl
    kubectx
    kubernetes-helm
    lorri
    nixfmt
    nodejs-18_x
    rustup
    std
    terraform
    tmux
    tree
    yarn
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
in nixTools