{ inputs, cell, }:
let inherit (inputs) nixpkgs;
in {
  nixTools = user: with nixpkgs; [
    ansible
    awscli2
    cachix
    delve
    direnv
    gh
    git-open
    gnupg
    go
    go-tools
    gopls
    helmfile
    htop
    inetutils
    kubectl
    kubectx
    kubernetes-helm
    lorri
    nixfmt
    nodejs-18_x
    rustup
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
  ] ++ user.packages or [];
}
