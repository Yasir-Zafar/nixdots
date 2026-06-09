# nixcord.nix — Full Vencord configuration via Nixcord
# Import this in home.nix:  imports = [ inputs.nixcord.homeModules.nixcord ./nixcord.nix ];
#
# See flake setup instructions at the bottom of this file (in comments).
{inputs, ...}: {
  programs.nixcord = {
    enable = true;

    # ─── Client ────────────────────────────────────────────────────────────────
    # Only enable ONE client block at a time.

    discord = {
      enable = true; # Set false to use only Vesktop/Legcord/etc.
      branch = "stable"; # "stable" | "ptb" | "canary" | "development"
      installPackage = true;

      commandLineArgs = ["--enable-blink-features=MiddleClickAutoscroll"];

      vencord = {
        enable = true; # Vencord injection (default client mod)
        unstable = false; # true = master branch build of Vencord
        # package = pkgs.callPackage ./vencord.nix {};   # override package
      };

      # equicord.enable = false;      # Alternative to Vencord (more plugins)

      openASAR.enable = true; # OpenASAR runtime replacement (perf boost)
      krisp.enable = false; # Krisp noise cancellation

      settings = {
        # Raw Discord settings.json entries, e.g.:
        # SKIP_HOST_UPDATE = true;
      };
    };

    # vesktop.enable = false;         # Vesktop (Vencord-bundled standalone client)
    # dorion.enable  = false;         # Dorion  (WebKitGTK-based; see note below)
    # legcord.enable = false;         # Legcord (lightweight client)

    # ─── Quick CSS ─────────────────────────────────────────────────────────────
    quickCss = ''
      /**
       * @name Gruvbox Dark
       * @description Gruvbox Dark for Discord (new UI update)
       * @author shved.
       * @version 0.0.1
       * @authorId 833767278969225266
       * @website https://github.com/shvedes/discord-gruvbox
      */

      * {
      	--gruv-dark-bg-hard: 29, 32, 33;
      	--gruv-dark-bg: 40 40 40;
      	--gruv-dark-bg-alt: 33, 33, 33;
      	--gruv-dark-bg-soft: 50, 48, 47;
      	--gruv-dark-bg1: 60, 56, 54;
      	--gruv-dark-bg2: 80, 73, 69;
      	--gruv-dark-bg3: 102, 92, 84;
      	--gruv-dark-bg4: 124, 111, 100;

      	--gruv-dark-fg-hard: 251, 241, 199;
      	--gruv-dark-fg: 235, 219, 178;
      	--gruv-dark-fg1: 213, 196, 161;
      	--gruv-dark-fg2: 189, 174, 147;
      	--gruv-dark-fg3: 168, 153, 132;

      	--gruv-dark-purple-dark: 177, 98, 134;
      	--gruv-dark-purple-light: 211, 134, 155;

      	--gruv-dark-yellow-dark: 215, 153, 33;
      	--gruv-dark-yellow-light: 250, 189, 47;

      	--gruv-dark-red-dark: 204, 36, 29;
      	--gruv-dark-red-light: 251, 73, 52;

      	--gruv-dark-orange-dark: 214, 93, 14;
      	--gruv-dark-orange-light: 254, 128, 25;

      	--gruv-dark-blue-dark: 69, 133, 136;
      	--gruv-dark-blue-light: 131, 165, 152;

      	--gruv-dark-green-dark: 152, 151, 26;
      	--gruv-dark-green-light: 184, 187, 38;

      	--gruv-dark-aqua-dark: 104, 157, 106;
      	--gruv-dark-aqua-light: 142, 192, 124;

      	--gruv-dark-gray-dark: 146, 131, 116;
      	--gruv-dark-gray-light: 168, 153, 132;

      	/* ============================================================== */

      	--gruv-dark-text-hard:           var(--gruv-dark-fg-hard);
      	--gruv-dark-text-primary:        var(--gruv-dark-fg);
      	--gruv-dark-text-secondary:      var(--gruv-dark-fg1);
      	--gruv-dark-text-tertiary:       var(--gruv-dark-fg2);
      	--gruv-dark-text-muted:          var(--gruv-dark-fg3);
      	--gruv-dark-text-danger:         var(--gruv-dark-red-light);
      	--gruv-dark-text-inverted-hard:  var(--gruv-dark-text-hard);
      	--gruv-dark-text-inverted:       var(--gruv-dark-bg);

      	--gruv-dark-background-positive: var(--gruv-dark-green-dark);

      	--gruv-dark-accent: var(--gruv-dark-green-light);
      	--gruv-dark-accent-hover: var(--gruv-dark-green-dark);

      	--gruv-dark-icon-color: var(--gruv-dark-fg2);
      	--gruv-dark-icon-color-hover: var(--gruv-dark-fg);
      	--gruv-dark-icon-color-hover-harder: var(--gruv-dark-fg-hard);
      	--gruv-dark-icon-color-muted: var(--gruv-dark-fg3);

      	--gruv-dark-link-color: var(--gruv-dark-blue-light);

      	--gruv-dark-border-default: var(--gruv-dark-bg2);
      	--gruv-dark-border-hover: var(--gruv-dark-bg3);

      	--gruv-dark-button-color-default: var(--gruv-dark-accent);
      	--gruv-dark-button-color-hover:   rgba(var(--gruv-dark-button-color-default), 0.7);
      	--gruv-dark-button-text-default: var(--gruv-dark-bg);
      	--gruv-dark-button-text-dark: var(--gruv-dark-text-primary);
      	--gruv-dark-button-text-dark-muted: var(--gruv-dark-text-muted);

      	--gruv-dark-button-alt-default: var(--gruv-dark-bg-soft);
      	--gruv-dark-button-alt-hover:   var(--gruv-dark-bg);

      	--gruv-dark-button-positive-default: var(--gruv-dark-green-dark);
      	--gruv-dark-button-positive-hover:   rgba(var(--gruv-dark-green-dark), 0.8);

      	--gruv-dark-input-box-background: var(--gruv-dark-bg-soft);

      	--gruv-dark-scrollbar-color: var(--gruv-dark-bg3);
      	--gruv-dark-scrollbar-background: transparent;

      	--gruv-dark-selected-tab: var(--gruv-dark-bg1);

      	--gruv-dark-status-online: var(--gruv-dark-green-dark);
      	--gruv-dark-status-offline: var(--gruv-dark-text-muted);
      	--gruv-dark-status-idle: rgba(var(--gruv-dark-accent), 0.8);
      	--gruv-dark-status-dnd: var(--gruv-dark-red-dark);

      	--vc-spotify-green: rgba(var(--gruv-dark-green-dark));
      	--vc-spotify-green-90: rgba(var(--gruv-dark-green-dark), 0.2);
      	--vc-spotify-green-80: rgba(var(--gruv-dark-green-dark), 0.3);
      }

      .visual-refresh.theme-dark,
      .visual-refresh .theme-dark,
      [class*=vc-membercount-total], /* vesktop plugin */
      .visual-refresh,
      .theme-dark {
      	--__header-bar-background: rgba(var(--gruv-dark-bg-hard));
      	--autocomplete-bg: rgba(var(--gruv-dark-bg));

      	--background-primary:  rgba(var(--gruv-dark-bg));      /* #282828 */
      	--background-secondary: rgba(var(--gruv-dark-bg-alt)) ; /* #212121 */
      	--background-secondary-alt: rgba(var(--gruv-dark-bg-soft));
      	--background-tertiary: rgba(var(--gruv-dark-bg-soft)); /* #32302f */

      	--background-base-lower: rgba(var(--gruv-dark-bg));
      	--background-base-low: rgba(var(--gruv-dark-bg));
      	--background-base-lowest: rgba(var(--gruv-dark-bg-hard));
      	--background-floating: rgba(var(--gruv-dark-bg-hard)); /* #1d2021 */

      	--background-surface-high: rgba(var(--gruv-dark-bg-soft));
      	--background-surface-higher: rgba(var(--gruv-dark-bg));
      	--background-surface-highest: rgba(var(--gruv-dark-bg));

      	--background-feedback-critical: rgba(var(--gruv-dark-red-dark), 0.08);
      	--background-feedback-positive: rgba(var(--gruv-dark-green-dark), 0.08);

      	--background-modifier-accent: rgba(var(--gruv-dark-border-default));
      	--background-modifier-selected: rgba(var(--gruv-dark-selected-tab));

      	--background-mentioned: rgba(var(--gruv-dark-accent), 0.1);
      	--background-mentioned-hover: rgba(var(--gruv-dark-accent), 0.15);

      	--background-message-automod: rgba(var(--gruv-dark-accent), 0.1);
      	--background-message-automod-hover: rgba(var(--gruv-dark-accent), 0.15);

      	--background-accent: rgba(var(--gruv-dark-bg1));

      	--bg-base-primary: rgba(var(--gruv-dark-bg));
      	--bg-base-secondary: rgba(var(--gruv-dark-bg));
      	--bg-base-tertiary: rgba(var(--gruv-dark-bg-hard));

      	--bg-surface-overlay: rgba(var(--gruv-dark-bg));

      	--card-primary-bg:  rgba(var(--gruv-dark-bg-hard));

      	--bg-brand: rgba(var(--gruv-dark-accent), 0.8);

      	--bg-mod-faint: rgba(var(--gruv-dark-bg-soft));
      	--bg-mod-strong: rgba(var(--gruv-dark-bg2));
      	--bg-mod-subtle: rgba(var(--gruv-dark-bg1));

      	--border-normal: rgba(var(--gruv-dark-border-default));
      	--border-strong: rgba(var(--gruv-dark-border-default));
      	--border-faint:  rgba(var(--gruv-dark-border-default));
      	--border-subtle: rgba(var(--gruv-dark-border-default));

      	--background-message-hover: rgba(var(--gruv-dark-bg1));

      	--text-primary: rgba(var(--gruv-dark-fg-hard)); /* #fbf1c7  */
      	--text-normal:  rgba(var(--gruv-dark-fg));      /* #ebdbb2  */
      	--text-default: rgba(var(--gruv-dark-fg));      /* #ebdbb2  */
      	--text-secondary: rgba(var(--gruv-dark-fg1));   /* #d5c4a1 */
      	--text-tertiary: rgba(var(--gruv-dark-fg2));    /* #bdae93 */
      	--text-positive: rgba(var(--gruv-dark-green-dark));

      	--chat-text-muted: var(--text-tertiary);
      	--embed-title: rgba(var(--gruv-dark-text-hard));

      	--text-link: rgba(var(--gruv-dark-link-color));
      	--text-muted: rgba(var(--gruv-dark-text-muted));
      	--text-brand: rgba(var(--gruv-dark-accent));
      	--text-muted-on-default: rgba(var(--gruv-dark-text-muted));

      	--text-feedback-positive: rgba(var(--gruv-dark-green-dark));

      	--text-code-comment: rgba(var(--gruv-dark-gray-light));
      	--text-code-default: rgba(var(--gruv-dark-blue-light));
      	--text-code-keyword: rgba(var(--gruv-dark-purple-light));
      	--text-code-variable: rgba(var(--gruv-dark-blue-light));
      	--text-code-builtin: rgba(var(--gruv-dark-purple-light));
      	--text-code-string: rgba(var(--gruv-dark-aqua-light));

      	--header-primary: rgba(var(--gruv-dark-text-primary));
      	--header-secondary: rgba(var(--gruv-dark-text-tertiary));
      	--header-muted: rgba(var(--gruv-dark-text-muted));

      	--checkbox-border-default: rgba(var(--gruv-dark-border-default));
      	--checkbox-border-checked: rgba(var(--gruv-dark-border-default));
      	--checkbox-background-default: rgba(var(--gruv-dark-bg-soft));
      	--checkbox-background-checked: rgba(var(--gruv-dark-background-positive));

      	--channel-icon: rgba(var(--gruv-dark-icon-color));
      	--channels-default: rgba(var(--gruv-dark-fg3));

      	--custom-notice-background: rgba(var(--gruv-dark-green-dark));
      	--custom-notice-text: rgba(var(--gruv-dark-text-hard));

      	--notice-background-positive: rgba(var(--gruv-dark-green-dark));
      	--notice-background-warning: rgba(var(--gruv-dark-yellow-dark), 0.8);
      	--notice-background-critical: rgba(var(--gruv-dark-red-dark));

      	--notice-text-positive: rgba(var(--gruv-dark-text-inverted-hard));

      	--link-color: rgba(var(--gruv-dark-blue-dark));

      	--icon-primary:   rgba(var(--gruv-dark-icon-color));
      	--icon-secondary: rgba(var(--gruv-dark-icon-color));
      	--icon-tertiary:  rgba(var(--gruv-dark-icon-color));
      	--icon-default:   rgba(var(--gruv-dark-icon-color));
      	--icon-muted:     rgba(var(--gruv-dark-icon-color-muted));

      	--input-background: rgba(var(--gruv-dark-input-box-background));
      	--input-border: rgba(var(--gruv-dark-border-default));
      	--input-placeholder-text: rgba(var(--gruv-dark-text-tertiary));

      	--modal-background: rgba(var(--gruv-dark-bg-hard));
      	--modal-footer-background: rgba(var(--gruv-dark-bg));

      	--mention-foreground: rgba(var(--gruv-dark-fg-hard));
      	--mention-background: rgba(var(--gruv-dark-bg2));

      	--scrollbar-auto-thumb: rgba(var(--gruv-dark-scrollbar-color));
      	--scrollbar-auto-track: rgba(var(--gruv-dark-scrollbar-background));
      	--scrollbar-thin-thumb: rgba(var(--gruv-dark-scrollbar-color));
      	--scrollbar-auto-scrollbar-color-thumb: rgba(var(--gruv-dark-scrollbar-color));
      	--scrollbar-auto-scrollbar-color-track: rgba(var(--gruv-dark-scrollbar-color));

      	--button-filled-brand-text: rgba(var(--gruv-dark-button-text-default));
      	--button-filled-brand-border: rgba(var(--gruv-dark-button-color-default));
      	--button-filled-brand-background: rgba(var(--gruv-dark-button-color-default));
      	--button-filled-brand-background-active: rgba(var(--gruv-dark-button-color-default));
          --button-filled-brand-background-hover: var(--gruv-dark-button-color-hover);

      	--button-danger-background:          rgba(var(--gruv-dark-red-dark));
      	--button-danger-background-active:   rgba(var(--gruv-dark-red-light));
      	--button-danger-background-disabled: rgba(var(--gruv-dark-red-dark), 0.8);
      	--button-danger-background-hover:    rgba(var(--gruv-dark-red-dark), 0.7);
      	--button-danger-border: rgba(var(--gruv-dark-red-dark));

      	--button-outline-danger-background: rgba(var(--gruv-dark-button-alt-default));
      	--button-outline-danger-background-hover: rgba(var(--gruv-dark-button-alt-hover));
      	--button-outline-danger-border: rgba(var(--gruv-dark-border-default));
      	--button-outline-danger-border-hover: rgba(var(--gruv-dark-border-default));
      	--button-outline-danger-text: rgba(var(--gruv-dark-button-text-dark-muted));
      	--button-outline-danger-text-hover: rgba(var(--gruv-dark-text-danger));

      	--button-outline-positive-text: rgba(var(--gruv-dark-text-primary));

      	--button-positive-background: rgba(var(--gruv-dark-button-positive-default));
      	--button-positive-background-hover: var(--gruv-dark-button-positive-hover);
      	--button-positive-background-active: rgba(var(--gruv-dark-button-positive-default));
      	--button-positive-background-disabled: rgba(var(--gruv-dark-green-dark));
      	--button-positive-border: rgba(var(--gruv-dark-button-positive-default));

      	--button-secondary-background: rgba(var(--gruv-dark-bg-soft));
      	--button-secondary-background-hover: rgba(var(--gruv-dark-bg));
      	--button-secondary-text: rgba(var(--gruv-dark-button-text-dark-muted));

      	--button-transparent-background: rgba(var(--gruv-dark-button-alt-default));
      	--button-transparent-background-hover: rgba(var(--gruv-dark-button-alt-hover));
      	--button-transparent-text: rgba(var(--gruv-dark-button-text-dark));

      	--primary-630: rgba(var(--gruv-dark-button-alt-default));
      	--primary-700: rgba(var(--gruv-dark-button-alt-hover));

      	--background-code: rgba(var(--gruv-dark-bg-hard));

      	--status-online: rgba(var(--gruv-dark-status-online));
      	--status-offline: rgba(var(--gruv-dark-status-offline));
      	--status-idle: var(--gruv-dark-status-idle);
      	--status-dnd: rgba(var(--gruv-dark-status-dnd));

      	--status-positive: rgba(var(--gruv-dark-green-dark));
      	--status-positive-background: rgba(var(--gruv-dark-green-dark));
      	--status-positive-text: rgba(var(--gruv-dark-text-inverted-hard));

      	--status-danger: rgba(var(--gruv-dark-red-dark));
      	--status-danger-background: rgba(var(--gruv-dark-red-dark));
      	--status-danger-text: rgba(var(--gruv-dark-text-primary));

      	--status-warning: rgba(var(--gruv-dark-orange-dark));
      	--status-warning-background: rgba(var(--gruv-dark-orange-dark));
      	--status-warning-text: rgba(var(--gruv-dark-text-inverted-hard));

      	--status-speaking: rgba(var(--gruv-dark-green-light));

      	--info-danger-background: rgba(var(--gruv-dark-red-dark), 0.08);
      	--info-danger-text: rgba(rgba(gruv-dark-red-light));

      	--info-help-foreground: rgba(var(--gruv-dark-blue-light));
      	--info-help-background: rgba(var(--gruv-dark-blue-dark), 0.1);

      	--info-positive-background: rgba(var(--gruv-dark-green-dark), 0.08);
      	--info-positive-text: rgba(var(--gruv-dark-green-light));

      	--info-warning-background: rgba(var(--gruv-dark-orange-dark), 0.08);
      	--info-warning-text: rgba(var(--gruv-dark-text-primary));

      	--background-mod-normal: rgba(var(--gruv-dark-selected-tab));
      	--background-mod-strong: rgba(var(--gruv-dark-bg2));
      	--background-mod-subtle: rgba(var(--gruv-dark-bg-soft));


      	--interactive-normal: rgba(var(--gruv-dark-icon-color));
      	--interactive-hover: rgba(var(--gruv-dark-icon-color-hover-harder));
      	--interactive-active: rgba(var(--gruv-dark-icon-color-hover-harder));
      	--interactive-muted: rgba(var(--gruv-dark-bg3));

      	--message-reacted-text: rgba(var(--gruv-dark-text-hard));
      	--message-reacted-background: rgba(var(--gruv-dark-accent), 0.1);

      	--background-message-highlight: rgba(var(--gruv-dark-accent), 0.1);
      	--background-message-highlight-hover: rgba(var(--gruv-dark-accent), 0.15);

      	--spoiler-hidden-background: rgba(var(--gruv-dark-bg2));
      	--spoiler-hidden-background-hover: rgba(var(--gruv-dark-bg3));

      	--chat-background-default: rgba(var(--gruv-dark-bg-soft));
      	--premium-nitro-pink-text: rgba(var(--gruv-dark-purple-light));
      	--guild-boosting-pink: rgba(var(--gruv-dark-purple-light));
      	--spine-default: rgba(var(--gruv-dark-bg4));
      	--app-border-frame: rgba(var(--gruv-dark-border-default));
      	--twitch: rgba(var(--gruv-dark-purple-dark));
      	--opacity-blurple-12: rgba(var(--gruv-dark-bg));

      	--custom-store-colors-premium-gradient: linear-gradient(90deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)));
      	--custom-premium-colors-premium-gradient-tier-0: linear-gradient(90deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)));
      	--custom-premium-colors-premium-gradient-tier-1: linear-gradient(90deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)));
      	--custom-premium-colors-premium-gradient-tier-2: linear-gradient(90deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)));
      	--custom-premium-colors-premium-gradient-tier-2-transparent: linear-gradient(90deg, rgba(var(--gruv-dark-purple-dark), 0.3), rgba(var(--gruv-dark-purple-light), 0.3));
      	--custom-premium-colors-premium-gradient-tier-2-diagonal: linear-gradient(45deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)));
      	--custom-premium-colors-premium-gradient-tier-2-tri-color: linear-gradient(90deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)), rgba(var(--gruv-dark-purple-dark)));
      	--custom-premium-colors-premium-gradient-tier-2-tri-color-reverse: linear-gradient(90deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)), rgba(var(--gruv-dark-purple-dark)));
      	--custom-premium-colors-premium-gradient-tier-2-tri-color-vertical: linear-gradient(0deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)), rgba(var(--gruv-dark-purple-dark)));
      	--custom-premium-colors-premium-gradient-tier-2-old: linear-gradient(90deg, rgba(var(--gruv-dark-purple-dark)), rgba(var(--gruv-dark-purple-light)));

      	--premium-nitro-pink-dark: rgba(var(--gruv-dark-purple-dark));
      	--premium-nitro-pink-light: rgba(var(--gruv-dark-purple-light));
      	--premium-perk-blue: rgba(var(--gruv-dark-blue-dark));
      	--premium-perk-blue-alt: rgba(var(--gruv-dark-blue-dark));
      	--premium-perk-dark-blue: rgba(var(--gruv-dark-blue-dark));

      	--brand-260: rgba(var(--gruv-dark-accent-hover), 0.8);
      	--brand-360: rgba(var(--gruv-dark-accent));
      	--brand-500: rgba(var(--gruv-dark-accent-hover), 0.8);
      	--brand-05: rgba(var(--gruv-dark-accent-hover), 0.2);
      	--white-500: rgba(var(--gruv-dark-text-hard));
      	--blurple-50: rgba(var(--gruv-dark-accent));
      	--green-300: rgba(var(--gruv-dark-green-dark));
      	--green-360: rgba(var(--gruv-dark-green-dark));
      	--color-total: rgba(var(--gruv-dark-text-muted));
      	--primary-300: rgba(var(--gruv-dark-text-hard));
      	--primary-500: rgba(var(--gruv-dark-bg1));
      	--white: rgba(var(--gruv-dark-text-hard));

      	--badge-brand-text: rgba(var(--gruv-dark-text-inverted));
      	--badge-brand-bg: rgba(var(--gruv-dark-accent-hover), 0.8);

      	--redesign-button-positive-background: rgba(var(--gruv-dark-green-dark));
      	--redesign-button-positive-pressed-background: rgba(var(--gruv-dark-green-dark), 0.8);
      	--redesign-button-positive-text: rgba(var(--gruv-dark-text-hard));
      	--redesign-button-overlay-alpha-text: rgba(var(--gruv-dark-text-hard));
      	--redesign-button-overlay-alpha-background: rgba(0, 0, 0, 0.3);

      	--user-profile-overlay-background: rgba(var(--gruv-dark-bg));

      	/* hasty fix for new update*/
      	--text-strong: var(--text-primary);
      	--icon-strong: var(--text-strong);
      	--interactive-text-hover: var(--text-strong);
      	--interactive-text-active: var(--text-strong);
          --interactive-text-default: var(--text-normal);
      	--icon-subtle: var(--text-strong);
      	--mobile-text-heading-primary: var(--text-strong);
      	--control-secondary-text-default: var(--text-secondary);
      	--control-secondary-text-hover: var(--text-secondary);
      	--text-subtle: var(--text-muted);
      }

      .visual-refresh .textBadge__2b1f5 {
      	color: rgb(var(--gruv-dark-text-inverted)) !important
      }

      /* Invite button inside call box */
      .buttonColor__7b3e8 {
      	color: rgba(var(--gruv-dark-text-primary))
      }

      .theme-dark .button_e131a9.buttonColor_e131a9.buttonActive_e131a9 {
      	background-color: rgba(var(--gruv-dark-button-positive-default), 0.1)
      }
      .theme-dark .button_e131a9.buttonColor_e131a9.buttonActive_e131a9:hover {
      	background-color: rgba(var(--gruv-dark-button-positive-default), 0.2)
      }

      /* Input / Output Volume slider (context menu) */
      :where(.visual-refresh) .mini_a562c8 .grabber_a562c8, :where(.visual-refresh) .slider_a562c8 .grabber_a562c8  {
      	background-color: rgba(var(--gruv-dark-text-primary))
      }

      [class*=notches_] {
      	background-color: rgba(var(--gruv-dark-bg3))
      }

      [class^=control_] [class*=checked_],
      #vc-spotify-player [class*=barFill_] {
        background-color: rgba(var(--gruv-dark-accent-hover), 0.8) !important;
      }

      .slider__87bf1 > rect {
      	fill: rgba(var(--gruv-dark-text-hard));
      }
      .slider__87bf1 svg > path {
      	fill: rgba(var(--gruv-dark-bg))
      }
      .container__87bf1 {
      	background-color: rgba(var(--gruv-dark-bg2)) !important
      }
      .checked__87bf1 {
          background-color: rgba(var(--gruv-dark-yellow-dark)) !important;
      }

      /* "Share your screen" button */
      .theme-dark [class*="experimentButton_"][class*="buttonColor_"][class*="buttonActive_"] {
      	background-color: rgba(var(--gruv-dark-green-dark), 0.2);
      	border: 1px solid rgba(var(--gruv-dark-green-dark), 0.25);
      }
      .theme-dark [class*="experimentButton_"][class*="buttonColor_"][class*="buttonActive_"]:hover {
      	background-color: rgba(var(--gruv-dark-green-dark), 0.4);
      	border: 1px solid rgba(var(--gruv-dark-green-dark), 0.3);
      }

      /* call container bg */
      [class^=callContainer],
      [class^=callContainer] [class^=scroller_] {
        background-color: rgba(var(--gruv-dark-bg-hard));
      }
      /* Room preview animation */
      .gradientBackground__11664 {
      	background: rgba(var(--gruv-dark-bg)) !important
      }
      .backgroundDark__11664 {
      	background: rgba(var(--gruv-dark-bg)) !important
      }
      .foregroundRing__11664 {
      	background: rgba(var(--gruv-dark-accent-hover), 0.3) !important
      }
      .foregroundBase__11664 {
      	background: rgba(var(--gruv-dark-accent-hover), 1) !important
      }

      /* Online statuses */
      [mask^="url(#svg-mask-status-online"] {
        fill: rgba(var(--gruv-dark-status-online));
      }

      [mask^="url(#svg-mask-status-dnd"] {
        fill: rgba(var(--gruv-dark-status-dnd));
      }

      [mask^="url(#svg-mask-status-idle"] {
        fill: var(--gruv-dark-status-idle);
      }

      [mask^="url(#svg-mask-status-offline"] {
        fill: rgba(var(--gruv-dark-status-offline));
      }

      [class^=avatarWrapper_] {
        [aria-label*=online i] svg > svg > rect {
          fill: rgba(var(--gruv-dark-status-online)) !important;
        }
      }
      [class^=avatarWrapper_] {
        [aria-label*=idle i] svg > svg > rect {
          fill: rgba(var(--gruv-dark-status-idle)) !important;
        }
      }

      [class^=avatarWrapper_] {
        [aria-label*=dnd i] svg > svg > rect {
          fill: rgba(var(--gruv-dark-status-dnd)) !important;
        }
      }

      [class^=avatarWrapper_] {
        [aria-label*=invisible i] svg > svg > rect {
          fill: rgba(var(--gruv-dark-status-offline)) !important;
        }
      }

      rect[fill="#43a25a"] {
          fill: var(--status-online);
      }

      rect[fill="#ca9654"] {
          fill: var(--status-idle);
      }

      rect[fill="#d83a42"] {
          fill: var(--status-dnd);
      }

      rect[fill="#82838b"] {
          fill: var(--status-offline);
      }

      div.status_a423bd {
          background-color: var(--status-online) !important;
      }

      /* Screenshare icon */
      .icon_c9d15c > path {
      	fill: rgba(var(--gruv-dark-accent))
      }

      [class^=callContainer] [class^=root] {
        background-color: rgba(var(--gruv-dark-bg-hard)) !important
      }

      .flex__7c0ba .lineClamp1__4bd52 {
      	color: rgba(var(--gruv-dark-text-hard)) !important
      }

      /* Vesktop plugins / themes */
      .vc-addon-card {
      	border: 1px solid rgba(var(--gruv-dark-border-default))
      }

      /* Use solid background for banners in the "Discover" category */
      .theme-dark .gradientOverlay_e9ef78,
      .theme-dark .bannerGradient__955a3 {
      	background-color: rgba(var(--gruv-dark-bg));
      	border-bottom: 1px solid rgba(var(--gruv-dark-border-hover))
      }

      /* Share your screen / Stop stream / change windows / ets bototm button inside call window */
      [class^="colorable_"][class*="greenGlow_"] {
      	background-color: rgba(var(--gruv-dark-green-dark), 0.2);
      }
      [class^="colorable_"][class*="greenGlow_"]:hover,
      [class^="colorable_"][class*="greenGlow_"][class*="popoutOpen_"] {
      	background-color: rgba(var(--gruv-dark-green-dark), 0.4);
      }

      /* Add right border for left section */
      .visual-refresh .sidebarList_c48ade {
      	border-right: 1px solid rgba(var(--gruv-dark-border-default))
      }

      /* N new messages */
      .newMessagesBar__0f481 {
      	background-color: rgba(var(--gruv-dark-bg-soft));
      	color: rgba(var(--gruv-dark-text-primary))
      }
      .visual-refresh .barButtonAlt__0f481:hover {
      	background-color: transparent
      }

      /* Open voice button */
      /* .custom-profile-theme.theme-dark .themeColor_fb7f94.secondary_fb7f94 { */
      /* 	background-color: rgba(var(--gruv-dark-button-alt-default)) */
      /* } */
      /* .custom-profile-theme.theme-dark .themeColor_fb7f94.secondary_fb7f94:hover { */
      /* 	background-color: rgba(var(--gruv-dark-button-alt-hover)) */
      /* } */
      .custom-profile-theme.theme-dark [class*=themeColor i][class*=secondary i] {
      	background-color: rgba(var(--gruv-dark-button-alt-default))
      }
      .custom-profile-theme.theme-dark [class*=themeColor i][class*=secondary i]:hover {
      	background-color: rgba(var(--gruv-dark-button-alt-hover))
      }

      .visual-refresh .section__00943 {
      	background-color: rgba(var(--gruv-dark-bg))
      }

      :where(.visual-refresh) .lookFilled__201d5.colorPrimary__201d5,
      :where(.visual-refresh) .medium_a45028 .inner_a45028 {
      	background-color: rgba(var(--gruv-dark-bg))
      }

      .menuOverlay_af7fb7,
      .card__39ec2 {
      	background-color: rgba(var(--gruv-dark-bg))
      }

      /* Background tweaks to fix Discord's inconsistent styling */

      .connection_c7f964,
      .connectContainer_c7f964,
      .appDetailsContainer__50a54 {
          background-color: rgba(var(--gruv-dark-bg-soft));
      	border: 1px solid rgba(var(--gruv-dark-border-default))
      }

      .background__1fed1,
      .background__1fed1 > .fieldList__1fed1 {
          background-color: var(--user-profile-overlay-background);
      }

      .badgeList__1fed1 {
          background-color: transparent;
      }

      /* Hovering over gifs would cause them to go blank  */
      .result__2dc39:after {
          content: normal;
      }

      /* Contrast for some action buttons was too high, so.. */
      /* To see changes: Settings > Authorized Apps */

      [class^="actionMenuButton_"] {
      	background-color: rgba(var(--gruv-dark-bg-soft));
      	border: 1px solid rgba(var(--gruv-dark-border-default));
      	border-radius: 12px
      }
      [class^="actionMenuButton_"]:hover {
      	background-color: rgba(var(--gruv-dark-bg));
      	border: 1px solid rgba(var(--gruv-dark-border-hover));
      }

      .visual-refresh .searchBar__35e86 {
      	border: none !important
      }

      /* Add border to account overview */
      /* Settings > My Account */
      [class^=accountProfileCard__] {
      	border: 1px solid rgba(var(--gruv-dark-border-default));
      }

      [class^=accountProfileCard__] {
      	box-shadow: 0 0 5px black !important
      }

      [class^=accountProfileCard__]:hover {
      	box-shadow: 0 0 10px black !important
      }

      .visual-refresh [class^=box_],
      [class^=appDetailsContainer],
      [class^=connectionOptionsWrapper] {
      	background-color: var(--background-base-low) !important
      }

      /* Make all titlebars the same */
      .visual-refresh .title_f75fb {
      	background-color: rgba(var(--gruv-dark-bg-hard)) !important
      }

      /* Remove bottom border for server title section */
      .visual-refresh [class^=header_] {
      	border-bottom: none !important
      }

      /* ==== Nuked elements ==== */

      /* Top to bottom */

      /* Quests banner */
      .wrapper__0d616 {
      	display: none !important
      }
    '';

    # ─── Core Vencord Config ───────────────────────────────────────────────────
    config = {
      useQuickCss = true; # Enable the quickCss block above
      frameless = true; # Remove window frame / titlebar
      transparent = false; # Window transparency
      disableMinSize = false; # Remove minimum window size restriction
      enableReactDevtools = false; # React DevTools (requires reload)
      autoUpdate = false; # Auto-update Vencord
      autoUpdateNotification = false; # Notify on auto-update
      notifyAboutUpdates = true; # Notify when a manual update is available

      # Themes
      themeLinks = [
        # "https://raw.githubusercontent.com/rose-pine/discord/main/rose-pine.theme.css"
      ];
      enabledThemeLinks = []; # Subset of themeLinks to actually activate
      themes = {
        # "my-theme" = ./themes/my-theme.css;
      };
      enabledThemes = []; # e.g. [ "my-theme.css" ]

      # ── Plugins (Shared – Vencord + Equicord) ──────────────────────────────
      plugins = {
        # ── UI / Visual ──────────────────────────────────────────────────────

        accountPanelServerProfile.enable = true; # Show server profile in account panel
        alwaysAnimate.enable = false; # Always animate animated avatars/emojis
        betterRoleDot.enable = true; # Improve role colour dots
        betterSettings.enable = true; # Improved settings UI
        biggerStreamPreview.enable = false; # Larger stream preview
        characterCounter.enable = false; # Message character counter
        clientTheme.enable = false; # Custom client accent colour
        colorSighted.enable = false; # Remove colourblind-friendly icons
        fixCodeblockGap.enable = false; # Fix gap below codeblocks
        fixImagesQuality.enable = false; # Force max image quality
        forceOwnerCrown.enable = false; # Always show owner crown icon
        memberCount.enable = false; # Show member count in sidebar
        mentionAvatars.enable = false; # Show avatars in @mentions
        noMosaic.enable = false; # Disable image mosaic layout
        noProfileThemes.enable = false; # Disable profile themes
        noTypingAnimation.enable = false; # Disable typing indicator animation
        pictureInPicture.enable = false; # PiP support for videos
        plainFolderIcon.enable = false; # Plain server-folder icon
        previewMessage.enable = false; # Preview formatted message before send
        roleColorEverywhere.enable = true; # Apply role colours in more places
        serverListIndicators.enable = false; # Add indicators to server list
        showAllMessageButtons.enable = false; # Always show message action buttons
        showConnections.enable = false; # Show linked accounts on profiles
        showHiddenThings.enable = false; # Reveal hidden UI elements
        showTimeoutDuration.enable = true; # Show timeout remaining duration
        themeAttributes.enable = true; # Extra CSS data attributes for themes
        unlockedAvatarZoom.enable = false; # Remove avatar zoom cap

        # ── Rich Presence / Activity ─────────────────────────────────────────

        appleMusicRichPresence.enable = false; # Apple Music → Discord status
        customIdle.enable = false; # Customise idle timeout behaviour
        customRpc.enable = false; # Manual custom Rich Presence
        gameActivityToggle.enable = false; # Quick-toggle game activity
        lastFmRichPresence.enable = false; # Last.fm → Discord status
        streamerModeOnStream.enable = false; # Auto streamer-mode when streaming
        webRichPresence.enable = false; # Browser-tab Rich Presence

        # ── Messaging / Chat ─────────────────────────────────────────────────

        betterRoleContext.enable = false; # Better role right-click menu
        betterSessions.enable = false; # Improved sessions management
        betterUploadButton.enable = false; # Improved upload button
        clearUrls.enable = false; # Strip tracking params from links
        copyEmojiMarkdown.enable = false; # Copy emoji as markdown
        copyFileContents.enable = false; # Copy file text contents
        copyStickerLinks.enable = false; # Copy sticker URLs
        copyUserUrls.enable = false; # Copy user profile URLs
        customCommands.enable = false; # Add custom slash commands
        dearrow.enable = false; # Replace YouTube titles/thumbnails
        disableCallIdle.enable = false; # Prevent idle disconnect in calls
        disableDeepLinks.enable = false; # Open links in browser not app
        dontRoundMyTimestamps.enable = false; # Exact message timestamps
        expressionCloner.enable = false; # Clone emoji/stickers to own server
        fakeNitro.enable = false; # Send animated emoji / use Nitro features
        fakeProfileThemes.enable = false; # Fake Nitro profile themes
        favoriteGifSearch.enable = false; # Search within favourite GIFs
        fixSpotifyEmbeds.enable = false; # Fix broken Spotify embeds
        fixYoutubeEmbeds.enable = false; # Fix broken YouTube embeds
        friendInvites.enable = false; # Manage friend invite links
        friendsSince.enable = false; # Show when you became friends
        fullSearchContext.enable = false; # More context in message search
        fullUserInChatbox.enable = false; # Show full username in chatbox
        gifPaste.enable = false; # Paste GIFs directly
        greetStickerPicker.enable = true; # Improved greet sticker UI
        hideMedia.enable = false; # Hide media embeds
        iLoveSpam.enable = false; # Disable spam filter warnings
        imageFilename.enable = false; # Improve image filenames
        imageLink.enable = false; # Make image URLs clickable
        imageZoom.enable = false; # Click-to-zoom images
        implicitRelationships.enable = true; # Show implicit friend relationships
        keepCurrentChannel.enable = true; # Stay in current channel on reload
        messageLatency.enable = false; # Show message send latency
        messageLinkEmbeds.enable = false; # Embed linked messages inline
        mutualGroupDms.enable = false; # Show mutual group DMs on profiles
        noMaskedUrlPaste.enable = false; # Paste raw URLs not masked links
        noMiddleClickPaste.enable = false; # Disable middle-click paste
        noReplyMention.enable = false; # Don't ping on reply by default
        noServerEmojis.enable = false; # Hide server emoji section
        noPendingCount.enable = false; # Hide pending friend request badge
        noUnblockToJump.enable = false; # Jump to msg without unblocking
        openInApp.enable = false; # Open links in desktop app
        overrideForumDefaults.enable = true; # Override forum channel defaults
        pauseInvitesForever.enable = false; # Pause invites indefinitely
        permissionFreeWill.enable = true; # Ignore channel permission checks
        permissionsViewer.enable = true; # View channel permissions detail
        pinDms.enable = false; # Pin DMs to top of list
        quickMention.enable = true; # Quick-mention from user popout
        quickReply.enable = false; # Keyboard shortcut to reply
        readAllNotificationsButton.enable = false; # "Mark all read" button
        relationshipNotifier.enable = false; # Notify on friend remove/block
        replaceGoogleSearch.enable = false; # Replace Google with custom engine
        replyTimestamp.enable = false; # Show timestamp on replied message
        revealAllSpoilers.enable = false; # Auto-reveal all spoilers
        reverseImageSearch.enable = false; # Right-click reverse image search
        sendTimestamps.enable = false; # Insert formatted timestamps
        shikiCodeblocks.enable = false; # Shiki syntax highlighting
        silentMessageToggle.enable = false; # Toggle silent message sending
        stickerPaste.enable = false; # Paste stickers from clipboard
        summaries.enable = false; # AI channel summaries
        superReactionTweaks.enable = false; # Tweak super-reaction behaviour
        translate.enable = false; # In-chat message translation
        unindent.enable = false; # Remove leading indent from code
        unsuppressEmbeds.enable = false; # Un-suppress hidden embeds
        userMessagesPronouns.enable = true; # Show pronouns in messages
        userVoiceShow.enable = false; # Show which VC users are in
        usrbg.enable = true; # Custom user banner backgrounds
        validReply.enable = true; # Fix invalid reply display
        validUser.enable = true; # Fix invalid user display

        # ── Voice / Audio ─────────────────────────────────────────────────────

        notificationVolume.enable = false; # Set notification volume
        spotifyCrack.enable = false; # Disable Spotify pause-on-media
        spotifyShareCommands.enable = false; # Spotify share slash commands
        vcNarrator.enable = false; # Narrate VC join/leave events
        voiceChatDoubleClick.enable = true; # Double-click to join VC
        voiceDownload.enable = false; # Download voice messages
        voiceMessages.enable = false; # Record & send voice messages
        volumeBooster.enable = false; # Boost output volume past 100%
        webScreenShareFixes.enable = true; # Fix screen-share on web

        # ── Notifications ─────────────────────────────────────────────────────

        crashHandler.enable = false; # Catch & recover from crashes
        noSystemBadge.enable = false; # Hide OS taskbar badge
        secretRingToneEnabler.enable = false; # Enable secret notification tones
        xsOverlay.enable = false; # Send notifications to XSOverlay (VR)

        # ── Developer / Debug ────────────────────────────────────────────────

        consoleJanitor.enable = false; # Filter noisy console output
        consoleShortcuts.enable = false; # Extra browser-console helpers
        f8Break.enable = false; # F8 debugger breakpoint
        noDevtoolsWarning.enable = false; # Suppress DevTools warning
        noF1.enable = false; # Disable F1 help shortcut
        reactErrorDecoder.enable = false; # Decode minified React errors
        startupTimings.enable = false; # Log startup performance
        webContextMenus.enable = false; # Restore right-click menus on web
        webKeybinds.enable = false; # Restore keybinds on web

        # ── Loading Screen ────────────────────────────────────────────────────

        loadingQuotes.enable = true; # Custom loading screen quotes

        # ── Accessibility ────────────────────────────────────────────────────

        betterGifAltText.enable = false; # Better alt text for GIFs
        ircColors.enable = false; # IRC-style username colours

        # ── Miscellaneous ─────────────────────────────────────────────────────

        decor.enable = true; # Custom avatar decorations
        hideAttachments.enable = false; # Hide attachment previews
        noOnboardingDelay.enable = false; # Skip onboarding animation
        petpet = {enable = false;}; # Pet the avatar (stays lowercase in JSON)

        # ── Vencord-only Plugins ─────────────────────────────────────────────

        alwaysExpandRoles.enable = true; # Always expand role list
        alwaysTrust.enable = true; # Skip external link warnings
        anonymiseFileNames.enable = false; # Anonymise uploaded filenames
        autoDndWhilePlaying.enable = true; # Auto DND when in a game
        betterFolders.enable = true; # Improved server folders UI
        betterGifPicker.enable = true; # Improved GIF picker
        blurNsfw.enable = false; # Blur NSFW channel images
        callTimer.enable = true; # Show call duration timer
        devCompanion.enable = false; # Vencord plugin dev helper
        experiments.enable = false; # Enable Discord experiments tab
        favoriteEmojiFirst.enable = false; # Sort favourite emoji to top
        messageClickActions.enable = false; # Actions on message double-click
        messageLogger.enable = false; # Log deleted/edited messages
        moreQuickReactions.enable = true; # More emoji in quick-react bar
        newGuildSettings.enable = true; # Better new-server defaults
        noBlockedMessages.enable = false; # Hide blocked user messages
        oneko.enable = false; # Neko cursor follower
        onePingPerDm.enable = false; # One notification ping per DM
        platformIndicators.enable = true; # Show platform (mobile/web/etc.)
        reviewDb.enable = false; # User review database
        serverInfo.enable = true; # Extra server info in sidebar
        showHiddenChannels.enable = true; # List locked/hidden channels
        showMeYourName.enable = true; # Show username alongside display name
        silentTyping.enable = false; # Don't send typing indicator
        sortFriendRequests.enable = false; # Sort requests by date
        spotifyControls.enable = false; # Spotify controls in sidebar
        textReplace.enable = false; # Auto replace text patterns
        typingIndicator.enable = true; # Show who is typing in channel list
        typingTweaks.enable = true; # Improve typing indicator display
        vencordToolbox.enable = false; # Quick-access Vencord toolbox
        whoReacted.enable = true; # See who reacted to a message
      };
    };

    # ─── Extra / per-client config overrides ──────────────────────────────────
    # These are merged on top of `config` for the specified client only.
    extraConfig = {}; # All clients
    vencordConfig = {}; # Vencord (Discord) only
    equicordConfig = {}; # Equicord (Discord) only
    vesktopConfig = {}; # Vesktop only
    equibopConfig = {}; # Equibop only

    # ─── Third-party user plugins ─────────────────────────────────────────────
    # After adding here, also enable the plugin under extraConfig.plugins.
    userPlugins = {
      # someCoolPlugin = "github:someUser/someCoolPlugin/abc123def456";
      # myLocalPlugin  = "/home/user/projects/myPlugin";  # needs --impure
      # anotherPlugin  = ./plugins/anotherPlugin;
    };
  };
}
# =============================================================================
# FLAKE SETUP INSTRUCTIONS
# =============================================================================
#
# 1.  Add nixcord to your flake inputs (flake.nix):
#
#       inputs = {
#         nixpkgs.url    = "github:NixOS/nixpkgs/nixos-25.11";
#         home-manager = {
#           url   = "github:nix-community/home-manager/release-25.11";
#           inputs.nixpkgs.follows = "nixpkgs";
#         };
#         nixcord.url = "github:FlameFlag/nixcord";
#       };
#
# 2.  Pass inputs through to your Home Manager config.
#     In your homeConfigurations output:
#
#       outputs = { nixpkgs, home-manager, nixcord, ... }@inputs: {
#         homeConfigurations."youruser" = home-manager.lib.homeManagerConfiguration {
#           pkgs = nixpkgs.legacyPackages.x86_64-linux;
#           extraSpecialArgs = { inherit inputs; };  # <-- important
#           modules = [
#             inputs.nixcord.homeModules.nixcord     # <-- import the module
#             ./home.nix
#             ./nixcord.nix                          # <-- this file
#           ];
#         };
#       };
#
# 3.  Rebuild:
#
#       home-manager switch --flake .#youruser
#
# ── NixOS (system-wide) ──────────────────────────────────────────────────────
#
#   In configuration.nix instead of home.nix:
#
#     imports = [ inputs.nixcord.nixosModules.nixcord ];
#     programs.nixcord = {
#       enable = true;
#       user   = "youruser";   # required at system level
#     };
#
#   Rebuild with:  sudo nixos-rebuild switch --flake .#yourhostname
#
# ── macOS / nix-darwin ───────────────────────────────────────────────────────
#
#   imports = [ inputs.nixcord.darwinModules.nixcord ];
#   programs.nixcord = {
#     enable = true;
#     user   = "youruser";
#   };
#
#   Rebuild with:  darwin-rebuild switch --flake .#yourhostname
#
# ── Dorion note ──────────────────────────────────────────────────────────────
#
#   Dorion requires existing LocalStorage DBs before the Nix config can manage
#   it.  Run it once first to create them:
#
#     nix run github:FlameFlag/nixcord#dorion
#
#   Log in, close it, then set dorion.enable = true and rebuild.
# =============================================================================

