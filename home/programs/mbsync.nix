{

  programs = {

    mbsync = {

      enable = true;
      extraConfig =
        "
        IMAPAccount gmail
        Host imap.gmail.com
        User dpix720@gmail.com
        PassCmd "gpg2 -q --for-your-eyes-only --no-tty -d ~/.dpix.txt.gpg"
        
        IMAPStore gmail-remote
        Account gmail

        MaildirStore gmail-local
        Path ~/Maildir/Gmail/
        Inbox ~/Maildir/Gmail/INBOX

        Channel gmail
        Master :gmail-remote:
        Slave :gmail-local:
        Patterns "INBOX"
        Create Both
        Expunge Both
        SyncState *

        # Enable UseGmailLabel for Gmail specific behavior
        Channel gmail
        Create Both
        Expunge Both
        SyncState *
        Automaton FileState
        Group mail
        UseGmailLabel yes
        RemoveDuplicates no
        MoveSpam nil
        Trash junk

        # Archive sent mail
        Channel gmail-inbox
        Patterns "INBOX"
        Create Both
        Expunge Both
        SyncState *
        Automaton FileState
        Group mail
        UseGmailLabel yes
        RemoveDuplicates no
        MoveSpam nil
        Trash Gmail

        IMAPAccount gmail265
        Host imap.gmail.com
        User yasirzafar365@gmail.com
        PassCmd "gpg2 -q --for-your-eyes-only --no-tty -d ~/.yz365.txt.gpg"

        IMAPStore gmail365-remote
        Account gmail365

        MaildirStore gmail365-local
        Path ~/Maildir/Gmail365/
        Inbox ~/Maildir/Gmail365/INBOX

        Channel gmail365
        Master :gmail365-remote:
        Slave :gmail365-local:
        Patterns "INBOX"
        Create Both
        Expunge Both
        SyncState *

        # Enable UseGmailLabel for Gmail specific behavior
        Channel gmail365
        Create Both
        Expunge Both
        SyncState *
        Automaton FileState
        Group mail
        UseGmailLabel yes
        RemoveDuplicates no
        MoveSpam nil
        Trash junk

# Archive sent mail
Channel gmail365-inbox
Patterns "INBOX"
Create Both
Expunge Both
SyncState *
Automaton FileState
Group mail
UseGmailLabel yes
RemoveDuplicates no
MoveSpam nil
Trash Gmail365

        "
        
    }
    
  }
  
}
