{
  inputs,
  cell,
  user,
  ...
}: {
  zsh = {
    enable = user.zsh or true;
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
        "operator-sdk"
        "poetry"
        "python"
        "rust"
        "terraform"
        "tmux"
      ];
      theme = "dst";
    };
    history = {size = 100000;};
    initExtraFirst = ''
      # python
      for dir in $(ls -rd $HOME/Library/Python/*); do
        export PATH="$dir/bin:$PATH"
      done
      # End python
      # Cargo
      export PATH="$HOME/.cargo/bin:$PATH"
      # End Cargo
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix
      # krew
      export PATH="$HOME/.krew/bin:$PATH"
      # End krew
    '';
    initExtra =
      ''
        bindkey '^f' autosuggest-accept
        # agenix
        export EDITOR="vim"
      ''
      + (
        if builtins.hasAttr "session_recording" user && user.session_recording
        then ''

          # Check if we are currently in an asciinema session
          if [[ -z "$ASCIINEMA_REC" ]]; then
            # Set the environment variable to indicate the recording is in progress
            export ASCIINEMA_REC=1

            # Define where to save the asciinema recording files
            ASCIINEMA_DIR="$HOME/.asciinema"
            mkdir -p "$ASCIINEMA_DIR"
            # Generate a unique filename for each session
            FILENAME="$ASCIINEMA_DIR/session_$(date "+%Y-%m-%d_%H-%M-%S").cast"
            # Start recording with asciinema
            asciinema rec "$FILENAME"
          fi
        ''
        else ""
      );
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
}
