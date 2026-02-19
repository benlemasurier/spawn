{ ... }:

{
  programs.git = {
    enable = true;

    signing = {
      key = "E8E74189";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Ben LeMasurier";
        email = "b@crypt.ly";
      };

      alias = {
        co = "checkout";
        br = "branch";
        s = "status";
        avs = "commit -av -S";
        unmerged = "branch --no-merged master";
      };

      core = {
        editor = "nvim";
        excludesFile = "~/.gitignore";
      };

      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
      };

      push.default = "current";
      status.showUntrackedFiles = "all";
      pull.rebase = false;

      rerere = {
        enabled = false;
        autoupdate = true;
      };

      init.defaultBranch = "main";
      safe.directory = [
        "/opt/esp-idf"
        "/opt/esp-idf/components"
        "/opt/esp-idf/components/openthread/openthread"
      ];
      url."git@github.com:lambdal/".insteadOf = "https://github.com/lambdal/";
    };

    includes = [
      {
        condition = "gitdir:~/code/lambda/";
        contents.user.email = "benl@lambda.ai";
      }
    ];
  };
}
