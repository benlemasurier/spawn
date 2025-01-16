_:

let
  user = "ben@crypt.ly";
  server = "mail.crypt.ly";
  passPath = "mail.crypt.ly/ben";
in {
  accounts = {
    calendar = {
      basePath = "calendar";

      accounts = {
        cryptly = {
          primary = true;

          khal = { enable = true; };

          remote = {
            type = "caldev";
            url = "https://${server}";
            userName = "ben@crypt.ly";
            passwordCommand = "pass ${passPath}";
          };
        };
      };
    };

    contact.accounts = {
      cryptly = {
        remote = {
          type = "carddav";
          url = "https://${server}";
          userName = user;
          passwordCommand = "pass ${passPath}";
        };

        #vdirsyncer = { enable = true; };

      };
    };

    email.accounts = {
      cryptly = {
        primary = true;
        address = user;
        realName = "Ben LeMasurier";
        userName = user;
        passwordCommand = "pass ${passPath}";

        himalaya.enable = true;

        imap = {
          host = server;
          port = 993;
          tls.enable = true;
        };

        smtp = {
          host = server;
          port = 587;
          tls.enable = true;
        };
      };
    };
  };
}
