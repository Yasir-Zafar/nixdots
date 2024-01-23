{

  programs = {

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

      [Filter.2]
      query = 'dpix720@gmail.com'
      tags = +dpix
      message = dpix mail

    '';
    
    };

  };

}
