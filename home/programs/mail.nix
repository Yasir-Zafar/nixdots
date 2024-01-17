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
    accounts.dpix720 = {
      address = "dpix720@gmail.com";
      gpg = {
        key = "7A6638770E9226E362EB49F89E5D62C1E2F63DAC";
        signByDefault = true;
      };
      imap.host = "imap.gmail.com";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      imapnotify.enable = true;
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Yasir Zafar";
      signature = {
        text = ''
        Yasir Zafar
        '';
        showSignature = "append";
      };
      passwordCommand = "gpg --quiet --for-your-eyes-only --no-tty -d ~/.dotfiles/mail/.mbsyncpass1.gpg";
      smtp = {
        host = "smtp.gmail.com";
      };
      userName = "dpix720@gmail.com";
    };
    
    accounts.fast = {
      address = "l233029@lhr.nu.edu.pk";
      gpg = {
        key = "36C09C293E0B5FE338528A5ADAC298A5208074AB";
        signByDefault = true;
      };
      imap.host = "imap.gmail.com";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      imapnotify.enable = true;
      msmtp.enable = true;
      notmuch.enable = true;
      realName = "Yasir Zafar";
      signature = {
        text = ''
        Yasir Zafar
        '';
        showSignature = "append";
      };
      passwordCommand = "gpg --quiet --for-your-eyes-only --no-tty -d ~/.dotfiles/mail/.mbsyncpass3.gpg";
      smtp = {
        host = "smtp.gmail.com";
      };
      userName = "l233029@lhr.nu.edu.pk";
    };
    
  };
}
