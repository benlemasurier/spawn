{ pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historySize = -1;
    historyFileSize = -1;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];

    initExtra = ''
      PROMPT_COLOR="1;32m"
      if [ "$TERM" != "dumb" ]; then
        PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
      fi
    '';

    shellAliases = {
      bc = "bc -l"; # always load math lib for decimals
      cat = "bat -pp"; # plain, disable paging
      k = "kubectl";
      tf = "terraform";
      ls = "eza";
      man = "batman";
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      pbcopy = "xclip -selection clipboard";
    };
  };
}
