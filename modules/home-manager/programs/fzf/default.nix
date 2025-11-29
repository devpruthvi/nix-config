{pkgs, ...}: let
  copyCmd =
    if pkgs.stdenv.isDarwin
    then "pbcopy"
    else "xclip -selection clipboard";
in {
  programs.fzf = {
    enable = true;

    defaultCommand = "find .";
    defaultOptions = [
      "--bind '?:toggle-preview'"
      "--bind 'ctrl-a:select-all'"
      "--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'"
      "--bind 'ctrl-y:execute-silent(echo {+} | ${copyCmd})'"
      "--height=40%"
      "--info=inline"
      "--layout=reverse"
      "--multi"
      "--preview '([[ -f {}  ]] && (bat --color=always --style=numbers,changes {} || cat {})) || ([[ -d {}  ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
      "--preview-window=:hidden"
    ];
  };

  stylix.targets.fzf.enable = true;
}
