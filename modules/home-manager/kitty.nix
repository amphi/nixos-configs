{ config, pkgs, ... }:
let
  kitty-cobalt2 = ".config/kitty/Cobalt2.conf";
  zsh-cobalt2 = ".oh-my-zsh/themes/cobalt2.zsh-theme";
in
{
  home.file."${kitty-cobalt2}".source = ./cobalt2.kitty-theme;
  home.file."${zsh-cobalt2}".source = ./cobalt2.zsh-theme;

  programs.starship = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    # Don't share command history between zsh sessions.
    history.share = false;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -ahl --color=auto";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "history"
        "themes"
      ];
      custom = "${config.home.homeDirectory}/.oh-my-zsh";
      theme = "cobalt2";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ];
  };


  programs.kitty = {
    enable = true;
    font.name = "'Source Code Pro'";

    theme = "Cobalt2";

    settings = {
      allow_remote_control = "yes";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 14;
      strip_trailing_spaces = "smart";
      enable_audio_bell = "no";
      term = "xterm-256color";
      macos_titlebar_color = "background";
      macos_option_as_alt = "yes";
      scrollback_lines = 10000;
      hide_window_decorations = "yes";

      tab_bar_edge = "top";
      tab_bar_style = "powerline";
    };

    keybindings = {
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      "alt+6" = "goto_tab 6";
      "alt+7" = "goto_tab 7";
      "alt+8" = "goto_tab 8";
      "alt+9" = "goto_tab 9";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.htop.enable = true;
}
