{
  inputs,
  cell,
  user,
  ...
}: {
  zsh = {
    enable = user.zsh or true;
    enableCompletion = true;
    autosuggestion.enable = true;
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
      # fzf.
      _fzf_comprun() {
        local command=$1
        shift
        case "$command" in
          cd)           fzf --preview 'eza --tree --color=always {} | head -200'   "$@" ;;
          export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
          ssh)          fzf --preview 'dig {}'                   "$@" ;;
          *)            fzf --preview 'bat -n --color=always {} --line-range :500 {}' "$@" ;;
        esac
      }
      source ~/.config/fzf-git.sh
      # End fzf
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
  eza = {
    enable = true;
  };
  bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
    themes = {
      dracula = {
        src = inputs.nixpkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "sublime"; # Bat uses sublime syntax for its themes
          rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
          sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
        };
        file = "Dracula.tmTheme";
      };
    };
  };
  fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type file --follow --hidden --color=always --exclude .git";
    defaultOptions = ["--ansi" "--bind ctrl-j:preview-up,ctrl-k:preview-down,ctrl-u:preview-half-page-up,ctrl-p:preview-half-page-down"];
    fileWidgetCommand = "fd --type file --follow --hidden --color=always --exclude .git";
    fileWidgetOptions = ["--ansi" "--preview-window 'right:57%'" "--preview 'bat -n --color=always --line-range :500 {}'"];
    changeDirWidgetCommand = "fd --type=d --follow --hidden --color=always --exclude .git";
    changeDirWidgetOptions = ["--ansi" "--preview 'eza --tree --color=always {} | head -200'"];
  };
  nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
}
