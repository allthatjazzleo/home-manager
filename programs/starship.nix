{ homeDirectory
, pkgs
, __user }:

{
  starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;
      aws.disabled = true;
      character = {
        format = "❯ ";
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
        truncation_length = 4;
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };
      git_commit = {
        commit_hash_length = 6;
        style = "bold blue";
        tag_symbol = "🔖 ";
        format = "[$hash$tag]($style) ";
      };
      git_status = {
        ahead = "🏎💨";
        behind = "😰";
        diverged = "😵";
        conflicted = "💥";
        deleted = "🗑";
        modified = "📝";
        renamed = "🏷";
        staged = "🔦";
        stashed = "📦";
        untracked = "🌚‍";
      };
      git_branch = {
        symbol = "🌱 ";
        truncation_length = 150;
        truncation_symbol = "…";
        style = "bold purple";
      };
      hostname.disabled = true;
      package.disabled = true;
      time = {
        disabled = false;
        format = "🕙[\\[ $time \\]]($style) ";
        time_format = "%T";
        utc_time_offset = "local";
      };
      username = {
        disabled = false;
        style_root = "green bold";
        format = "😈 [$user]($style) ";
        show_always = true;
      };
      rust = {
        disabled = false;
        format = "via [🦀 $version](red bold) ";
      };      
      python = {
        format = "via [🐍 $version](bold green) ";
        style = "bold yellow";
        pyenv_version_name = true;
      };
      nodejs = {
        format = "via [🤖 $version](bold green) ";
      };
      golang = {
        format = "via [🏎💨 $version](bold cyan) ";
      };
      terraform = {
        format = "via [🏎💨 $version$workspace]($style) ";
      };
      kubernetes = {
        format = "on [⛵ ($user on )($cluster in )$context \($namespace\)](dimmed green) ";
        disabled = false;
        context_aliases = {
          "dev.local.cluster.k8s" = "dev";
          ".*/openshift-cluster/.*" = "openshift";
          "gke_.*_(?P<var_cluster>[\w-]+)" = "gke-$var_cluster";
        };
        user_aliases = {
          "dev.local.cluster.k8s" = "dev";
          "root/.*" = "root";
        };
      };
    };
  };
}