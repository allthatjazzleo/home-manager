{
  inputs,
  cell,
  user,
  ...
}: {
  starship = {
    enable = user.starship or true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;
      command_timeout = 1000;
      aws.disabled = true;
      format = "$time$all";
      character = {
        format = "\\$ "; # escape the dollar sign
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        disabled = false;
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
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        conflicted = "💥";
        deleted = "🗑$count";
        modified = "📝$count";
        renamed = "🏷";
        staged = "[++($count)](green)";
        stashed = "📦$count";
        untracked = "🤷$count";
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
        format = "🕙[\\[$time\\]]($style) ";
        time_format = "%T";
        utc_time_offset = "local";
      };
      username = {
        disabled = false;
        style_user = "green bold";
        format = "[$user]($style) ";
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
      nodejs = {format = "via [🤖 $version](bold green) ";};
      golang = {format = "via [🏎💨 $version](bold cyan) ";};
      terraform = {format = "via [🏎💨 $version$workspace]($style) ";};
      kubernetes = {
        format = "on [⛵ ($user on )($cluster in )($namespace)](dimmed green) ";
        disabled = false;
        context_aliases = {
          "dev.local.cluster.k8s" = "dev";
          ".*/openshift-cluster/.*" = "openshift";
          "gke_.*_(?P<var_cluster>[w-]+)" = "gke-$var_cluster";
        };
        user_aliases = {
          "dev.local.cluster.k8s" = "dev";
          "root/.*" = "root";
        };
      };
    };
  };
}
