{ pkgs, ... }:{

  programs = {

    ncmpcpp = {

      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; clockSupport = true; };
      settings = {

        autocenter_mode = "yes";
        lyrics_directory = "~/.config/ncmpcpp";
        ignore_leading_the = "yes";
        ignore_diacritics = "yes";
        default_place_to_search_in = "database";
        execute_on_song_change = "~/.config/ncmpcpp/notify_mpd.sh";

        visualizer_data_source = "/tmp/mpd.fifo";
        visualizer_output_name = "my_fifo";
        visualizer_in_stereo = "yes";
        visualizer_type = "wave_filled";
        visualizer_look = "+|";

        header_visibility = "no";
        header_window_color = "default";
        volume_color = "default";
        state_line_color = "black";

        playlist_display_mode = "classic";
        song_list_format = "$7%b $R$6%t";
        now_playing_prefix = "$b$5";
        now_playing_suffix = "$/b$6";

        progressbar_look = "━━━";
        progressbar_color = "black";
        progressbar_elapsed_color = "white";
        statusbar_visibility = "no";
        statusbar_color = "default";
        song_status_format = "{{%a{ - %t}}|{ - %f}{ - %b{ (%y)}}}";

        song_library_format = "{{%a - %t}|{%f}}{$R%l}";
        empty_tag_color = "black";

        colors_enabled = "yes";
        main_window_color = "red";
        centered_cursor = "yes";
        enable_window_title = "yes";
        external_editor = "nvim";

      };

    };

  };

}
