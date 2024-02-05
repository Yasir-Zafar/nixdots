{ 

  networking = {

    hostName = "dpix";
    networkmanager.enable = true;

    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    firewall = { 
    
      enable = true;
      allowedTCPPortRanges = [ 
    
        { from = 1714; to = 1764; } # KDE Connect
      
      ];  
      allowedUDPPortRanges = [ 
      
        { from = 1714; to = 1764; } # KDE Connect
      
      ];  
    
    };  

  };

}
