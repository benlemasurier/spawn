_:

{
  accounts.email.accounts = {
    cryptly = {
      primary = true;
      address = "ben@crypt.ly";
      realName = "Ben LeMasurier";
      userName = "ben";
      passwordCommand = "pass mail.crypt.ly/ben";

      himalaya.enable = true;

      imap = {
        host = "mail.crypt.ly";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "mail.crypt.ly";
        port = 587;
        tls.enable = true;
      };
    };
  };
}
