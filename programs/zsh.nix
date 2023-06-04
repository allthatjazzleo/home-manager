{ homeDirectory
, pkgs
, __user }:

{
  zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      ll = "ls -l";
      # update = "home-manager switch --impure";
      j= "jump";
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
    history = {
      size = 100000;
    };
    initExtraFirst = ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix
    '';
    initExtra = ''
      bindkey '^f' autosuggest-accept
    '';
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}