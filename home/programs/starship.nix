{

  programs = {

    starship = {

      enable = true;
      enableZshIntegration = true;
      settings = {

        add_newline = true;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
        nix_shell.disabled = true;
        rust.disabled = true;

      };

    };

  };

}
