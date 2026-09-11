{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      # iNiR (Niri) session isolation: keep original Fish shell & wallpaper colors
      if [[ "$XDG_CURRENT_DESKTOP" == "niri" ]] || { [[ -z "$XDG_CURRENT_DESKTOP" ]] && pgrep -u "$USER" -x niri >/dev/null 2>&1; }; then
        export XDG_CURRENT_DESKTOP="niri"
        if [ -f "$HOME/.local/state/quickshell/user/generated/terminal/sequences.txt" ]; then
          command cat "$HOME/.local/state/quickshell/user/generated/terminal/sequences.txt" 2>/dev/null
        fi
        if [[ $- == *i* ]] && [[ -z "$IN_FISH" ]] && command -v fish &>/dev/null; then
          export IN_FISH=1
          export SHELL=$(which fish)
          exec fish -l
        fi
        return 0 2>/dev/null || exit 0
      fi

      '' + builtins.readFile ./shell-common.sh + ''
      
      # If this is an interactive bash shell with a valid TTY, drop directly into zsh
      if [[ $- == *i* && -t 0 && -t 1 ]]; then
        export SHELL=$(which zsh)
        exec zsh -l
      fi

      if command -v fnm &>/dev/null; then eval "$(fnm env --use-on-cd --shell bash)"; fi
    '';
  };
}
