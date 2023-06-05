{ pkgs }:

let
  nixTools = with pkgs; [
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
    terraform
    tmux
    tree
    yarn
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
in nixTools