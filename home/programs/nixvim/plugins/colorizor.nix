{
  programs.nixvim = {
    plugins.colorizer = {
      enable = true;
      userDefaultOptions = {
        names = true;
        RGB = true;
        RRGGBB = true;
        rgb_fn = true;
        hsl_fn = true;
        css = true;
        css_fn = true;
      };
    };
  };
}
