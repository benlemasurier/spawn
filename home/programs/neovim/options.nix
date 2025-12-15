{ config, ... }:
{
  programs.nixvim.opts = {
    # files
    swapfile = false; # don't create swapfiles
    undodir = "${config.xdg.stateHome}/.vim/backups";
    undofile = true;

    # windows
    title = true; # set the window title to the current filename
    updatetime = 300; # CursorHold event timeout (start completion, in ms)
    winminheight = 0; # minimum window height
    signcolumn = "yes"; # always reserve space for diagnostics

    # scrolling
    scrolloff = 8; # minimum lines to keep above/below cursor
    sidescrolloff = 15; # minimum columns to keep left/right of cursor

    # lines
    number = true; # show line numbers
    wrap = false; # don't wrap lines

    # tabs
    softtabstop = 4;
    shiftwidth = 4;

    # syntax
    showmatch = true; # show matching brackets

    # indentation
    # fixme: disabling for now because this is what's causing comments to
    # start at the beginning of the line
    smartindent = false;

    # listchars
    listchars = {
      eol = "↵"; # end of line
      nbsp = "."; # non-breaking spaces
      trail = "·"; # trailing spaces
      tab = "  "; # don't show tabs
      extends = "…"; # line wrap
    };

    # searching
    ignorecase = true; # ignore case when searching
    smartcase = true; # unless query contains a capital
  };
}
