{ pkgs, ... }:
{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  accounts.email = {
    accounts.posteo = {
      address = "dpix720@gmail.com";
      gpg = {
        key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
        signByDefault = true;
      };
      imap.host = "gmail";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Yasir";
      signature = {
        text = ''
          Yasir Zafar
          23L-3029
          BSSE-2A1
        '';
        showSignature = "append";
      };
      passwordCommand = "mail-password";
      smtp = {
        host = "gmail";
      };
      userName = "dpix720@gmail";
    };
  };
}
