# home/system/qt.nix
{ config, lib, pkgs, ... }:

{
  # Qt configuration
  qt = {
    enable = true;
    platformTheme = "qtct";
    style = {
      name = "kvantum";
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;
    };
  };

  # Install Qt theming packages
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    qt6ct
    libsForQt5.breeze-qt5
    libsForQt5.breeze-icons
    breeze-icons
    breeze-gtk
    adwaita-qt
    adwaita-qt6
    
    # Install Kvantum theme
    (catppuccin-kvantum.override {
      accent = "Blue";
      variant = "Mocha";
    })
  ];

  # Configure Kvantum theme
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Mocha-Blue
    '';
    
    # Configure Qt5ct
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      custom_palette=false
      icon_theme=Papirus-Dark
      standard_dialogs=default
      style=kvantum

      [Fonts]
      fixed="JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0,Regular"
      general="Inter,11,-1,5,50,0,0,0,0,0,Regular"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3
    '';
    
    # Configure Qt6ct
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      custom_palette=false
      icon_theme=Papirus-Dark
      standard_dialogs=default
      style=kvantum

      [Fonts]
      fixed="JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0,Regular"
      general="Inter,11,-1,5,50,0,0,0,0,0,Regular"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3
    '';
  };
}
