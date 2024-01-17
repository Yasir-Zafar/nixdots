{

  afew = {

    enable = true;
    extraConfig = ''
      [SpamFilter]
      [KillThreadsFilter]
      [ListMailsFilter]
      [ArchiveSentMailsFilter]
      [InboxFilter]

      [Filter.1]
      query = 'l233029@lhr.nu.edu.pk'
      tags = +fast
      message = Fast Mail

    '';
    
  };

}
