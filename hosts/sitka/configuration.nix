{ pkgs, ... }:

{
  # nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; };
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # system
  system.primaryUser = "ben";
  networking.hostName = "sitka";
  time.timeZone = "America/Denver";

  # default shell
  users.users.ben = {
    home = "/Users/ben";
    shell = pkgs.bash;
  };
  environment.shells = [ pkgs.bash ];
  programs.bash.enable = true;

  # macOS defaults
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0; # no delay
      launchanim = false;
      mineffect = "scale";
      show-recents = false;
      tilesize = 42;
      wvous-br-corner = 14; # quick note
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # list view
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowPathbar = true;
      ShowRemovableMediaOnDesktop = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ApplePressAndHoldEnabled = false; # enable key repeat
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTableViewDefaultSizeMode = 2;
      "com.apple.swipescrolldirection" = true;
      "com.apple.trackpad.forceClick" = true;
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.5;
      "com.apple.sound.beep.feedback" = 0;
    };

    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 1;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
    };

    SoftwareUpdate = {
      AutomaticallyInstallMacOSUpdates = false;
    };

    # settings not exposed by nix-darwin directly
    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleAccentColor = -1; # graphite
        AppleAquaColorVariant = 6; # graphite
        AppleHighlightColor = "0.698039 0.843137 1.000000 Blue";
        AppleAntiAliasingThreshold = 4;
        AppleMiniaturizeOnDoubleClick = false;
        NSMenuEnableActionImages = false; # hide Tahoe menu icons
      };
    };

    trackpad = {
      Clicking = false;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };
  };

  # Used for backwards compat; don't change.
  system.stateVersion = 6;
}
