{ inputs, cell, ... }:

{
  zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -alh";
      j = "jump";
      o = "open";
      kctx = "kubectx";
      kns = "kubens";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "ansible"
        "aws"
        "brew"
        "docker"
        "docker"
        "docker-compose"
        "git"
        "golang"
        "helm"
        "history"
        "history-substring-search"
        "jump"
        "kubectl"
        "microk8s"
        "oc"
        "poetry"
        "python"
        "rust"
        "terraform"
        "tmux"
      ];
      theme = "dst";
    };
    history = { size = 100000; };
    initExtraFirst = ''
      # Cargo
      export PATH="$HOME/.cargo/bin:$PATH"
      # End Cargo
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix
    '';
    initExtra = ''
      bindkey '^f' autosuggest-accept
      # agenix
      export EDITOR="vim"
    '';
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
