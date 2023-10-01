bg0_hard = "#1d2021"
bg0_soft = '#32302f'
bg0_normal = '#282828'

bg0 = bg0_normal
bg1 = "#3c3836"
bg2 = "#504945"
bg3 = "#665c54"
bg4 = "#7c6f64"

fg0 = "#fbf1c7"
fg1 = "#ebdbb2"
fg2 = "#d5c4a1"
fg3 = "#bdae93"
fg4 = "#a89984"

bright_red = "#fb4934"
bright_green = "#b8bb26"
bright_yellow = "#fabd2f"
bright_blue = "#83a598"
bright_purple = "#d3869b"
bright_aqua = "#8ec07c"
bright_gray = "#928374"
bright_orange = "#fe8019"

dark_red = "#cc241d"
dark_green = "#98971a"
dark_yellow = "#d79921"
dark_blue = "#458588"
dark_purple = "#b16286"
dark_aqua = "#689d6a"
dark_gray = "#a89984"
dark_orange = "#d65d0e"

# Completion
c.colors.completion.fg = [fg1, bright_aqua, bright_yellow]
c.colors.completion.odd.bg = bg0
c.colors.completion.even.bg = c.colors.completion.odd.bg
c.colors.completion.category.fg = bright_blue
c.colors.completion.category.bg = bg1
c.colors.completion.category.border.top = c.colors.completion.category.bg
c.colors.completion.category.border.bottom = c.colors.completion.category.bg
c.colors.completion.item.selected.fg = fg0
c.colors.completion.item.selected.bg = bg4
c.colors.completion.item.selected.border.top = bg2
c.colors.completion.item.selected.border.bottom = c.colors.completion.item.selected.border.top
c.colors.completion.item.selected.match.fg = bright_orange
c.colors.completion.match.fg = c.colors.completion.item.selected.match.fg
c.colors.completion.scrollbar.fg = c.colors.completion.item.selected.fg
c.colors.completion.scrollbar.bg = c.colors.completion.category.bg
c.colors.contextmenu.disabled.bg = bg3
c.colors.contextmenu.disabled.fg = fg3
c.colors.contextmenu.menu.bg = bg0
c.colors.contextmenu.menu.fg = fg2
c.colors.contextmenu.selected.bg = bg2
c.colors.contextmenu.selected.fg = c.colors.contextmenu.menu.fg
c.colors.downloads.bar.bg = bg0
c.colors.downloads.start.fg = bg0
c.colors.downloads.start.bg = bright_blue
c.colors.downloads.stop.fg = c.colors.downloads.start.fg
c.colors.downloads.stop.bg = bright_aqua
c.colors.downloads.error.fg = bright_red

# Hints
c.colors.hints.fg = bg0
c.colors.hints.bg = 'rgba(250, 191, 47, 200)'  # bright_yellow
c.colors.hints.match.fg = bg4

# Keyhint widget
c.colors.keyhint.fg = fg4
c.colors.keyhint.suffix.fg = fg0
c.colors.keyhint.bg = bg0

# Messages
c.colors.messages.error.fg = bg0
c.colors.messages.error.bg = bright_red
c.colors.messages.error.border = c.colors.messages.error.bg
c.colors.messages.warning.fg = bg0
c.colors.messages.warning.bg = bright_purple
c.colors.messages.warning.border = c.colors.messages.warning.bg
c.colors.messages.info.fg = fg2
c.colors.messages.info.bg = bg0
c.colors.messages.info.border = c.colors.messages.info.bg

# Prompts
c.colors.prompts.fg = fg2
c.colors.prompts.border = f'1px solid {bg1}'
c.colors.prompts.bg = bg3
c.colors.prompts.selected.bg = bg2

# Statusbar
c.colors.statusbar.normal.fg = fg2
c.colors.statusbar.normal.bg = bg0
c.colors.statusbar.insert.fg = bg0
c.colors.statusbar.insert.bg = dark_aqua
c.colors.statusbar.passthrough.fg = bg0
c.colors.statusbar.passthrough.bg = dark_blue
c.colors.statusbar.private.fg = bright_purple
c.colors.statusbar.private.bg = bg0
c.colors.statusbar.command.fg = fg3
c.colors.statusbar.command.bg = bg1
c.colors.statusbar.command.private.fg = c.colors.statusbar.private.fg
c.colors.statusbar.command.private.bg = c.colors.statusbar.command.bg
c.colors.statusbar.caret.fg = bg0
c.colors.statusbar.caret.bg = dark_purple
c.colors.statusbar.caret.selection.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.caret.selection.bg = bright_purple
c.colors.statusbar.progress.bg = bright_blue
c.colors.statusbar.url.fg = fg4
c.colors.statusbar.url.error.fg = dark_red
c.colors.statusbar.url.hover.fg = bright_orange
c.colors.statusbar.url.success.http.fg = bright_red
c.colors.statusbar.url.success.https.fg = fg0
c.colors.statusbar.url.warn.fg = bright_purple

# tabs
c.colors.tabs.bar.bg = bg0
c.colors.tabs.indicator.start = bright_blue
c.colors.tabs.indicator.stop = bright_aqua
c.colors.tabs.indicator.error = bright_red
c.colors.tabs.odd.fg = fg2
c.colors.tabs.odd.bg = bg2
c.colors.tabs.even.fg = c.colors.tabs.odd.fg
c.colors.tabs.even.bg = bg3
c.colors.tabs.selected.odd.fg = fg2
c.colors.tabs.selected.odd.bg = bg0
c.colors.tabs.selected.even.fg = c.colors.tabs.selected.odd.fg
c.colors.tabs.selected.even.bg = bg0
c.colors.tabs.pinned.even.bg = bright_green
c.colors.tabs.pinned.even.fg = bg2
c.colors.tabs.pinned.odd.bg = bright_green
c.colors.tabs.pinned.odd.fg = c.colors.tabs.pinned.even.fg
c.colors.tabs.pinned.selected.even.bg = bg0
c.colors.tabs.pinned.selected.even.fg = c.colors.tabs.selected.odd.fg
c.colors.tabs.pinned.selected.odd.bg = c.colors.tabs.pinned.selected.even.bg
c.colors.tabs.pinned.selected.odd.fg = c.colors.tabs.selected.odd.fg

config.load_autoconfig(False)
c.downloads.location.directory = '~/Data/Downloads'

# Cookies
config.set("colors.webpage.darkmode.enabled", False)
config.set('content.cookies.accept', 'never', 'chrome-devtools://*')
config.set('content.cookies.accept', 'never', 'devtools://*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://docs.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://drive.google.com/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt', 'https://easylist.to/easylist/easyprivacy.txt', 'https://easylist-downloads.adblockplus.org/easylistdutch.txt', 'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt', 'https://www.i-dont-care-about-cookies.eu/abp/', 'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt']

# UI
c.tabs.show = 'multiple'
c.statusbar.show = 'in-mode'
c.tabs.favicons.show = 'never'
c.scrolling.smooth = True
c.auto_save.session = True
c.tabs.tooltips = False
c.qt.highdpi = True
c.tabs.indicator.width = 0
c.prompt.radius = 0
c.completion.scrollbar.padding = 0
c.completion.scrollbar.width = 10

c.tabs.padding = {'bottom': 10, 'left': 10, 'right': 10, 'top': 10}
c.statusbar.padding = {'bottom': 10, 'left': 10, 'right': 10, 'top': 10}

# Startpage
c.url.default_page = 'https:///google.com/'
c.url.start_pages = 'https://google.com/'
c.url.searchengines = {'DEFAULT': 'https://google.com/search?q={}'}

# Font
c.fonts.default_family = '"JetBrainsMono Nerd Font"'
c.fonts.default_size = '10pt'
c.fonts.completion.entry = '10pt "JetBrainsMono Nerd Font"'
c.fonts.debug_console = '10pt "JetBrainsMono Nerd Font"'
c.fonts.prompts = 'default_size JetBrainsMono Nerd Font'
c.fonts.statusbar = '10pt "JetBrainsMono Nerd Font"'

# Bindings
config.bind('M', 'hint links spawn mpv {hint-url}')
config.bind('Z', 'hint links spawn st -e youtube-dl {hint-url}')
config.bind('t', 'cmd-set-text -s :open -t')
config.bind('xb', 'config-cycle statusbar.show always never')
config.bind('xt', 'config-cycle tabs.show always never')
