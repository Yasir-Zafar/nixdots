{

  services = {

    swayidle = {
      enable = true;
      events = 
        [

          { event = "before-sleep"; command = "swaylock"; }
          { event = "after-resume"; command = "hyprctl dispatch dpms on"; }

        ];

      timeouts = 

        [
        
          { timeout = 200; command = "swaylock"; }
          { timeout = 10; command = "hyprctl dispatch dpms off"; }

        ];

    };

  };

}
