{
  lib,
  pkgs,
  hostname,
  ...
}:

{
  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override { cfg.speechSynthesisSupport = false; };
    profiles.default.settings = {
      # compact ui: remove minimize, maximize, close buttons
      "browser.tabs.inTitleBar" = 0;
    }
    // lib.optionalAttrs (hostname == "pine") {
      # scale ui to a reasonable size
      "layout.css.devPixelsPerPx" = "0.6";
    };
  };
}
