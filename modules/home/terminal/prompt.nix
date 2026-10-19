# One prompt for fish, zsh and bash, styled like the pure prompt fish used before:
# single line, path in blue, branch in green, a yellow * when dirty, ❯ red on error.
{
  # fish only: once a command is run, its prompt line shrinks to just the ❯ (red if it failed),
  # which keeps the scrollback clean. zsh and bash keep the full prompt.
  programs.fish.functions.starship_transient_prompt_func = "starship module character";

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableTransience = true;

    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$git_state$nix_shell$cmd_duration$character";

      directory = {
        style = "bold bright-blue";
        truncation_length = 4;
        truncate_to_repo = false;
      };

      git_branch = {
        format = "[$branch]($style) ";
        style = "green";
      };

      git_status = {
        format = "[$modified$untracked$staged$renamed$deleted$ahead_behind]($style) ";
        style = "yellow";
        modified = "*";
        untracked = "*";
        staged = "*";
        renamed = "*";
        deleted = "*";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇡⇣";
      };

      nix_shell = {
        format = "[$symbol]($style) ";
        symbol = "❄";
        style = "bright-blue";
      };

      cmd_duration = {
        min_time = 5000;
        format = "[$duration]($style) ";
        style = "bright-yellow";
      };

      character = {
        success_symbol = "[❯](bright-green)";
        error_symbol = "[❯](bright-red)";
      };
    };
  };
}
