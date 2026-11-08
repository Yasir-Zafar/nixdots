;;; early-init.el --- before the first frame -*- lexical-binding: t -*-
;; Linked from the repo by modules/home/development/editors/emacs/default.nix.

;; Fewer garbage collections while starting; gcmh takes over afterwards (init.el).
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Packages come from Nix, already byte- and native-compiled. Nix installs them as a package.el
;; directory, so package activation stays on (it loads their autoloads); init.el empties
;; package-archives, so nothing is ever downloaded.

;; ~/.config/emacs is linked from the repo, so state lives elsewhere (XDG state/cache).
(defconst my/state-dir
  (expand-file-name "emacs/" (or (getenv "XDG_STATE_HOME") "~/.local/state")))
(defconst my/cache-dir
  (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME") "~/.cache")))
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache (expand-file-name "eln-cache/" my/cache-dir)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Draw the frame once, without bars, instead of flashing the defaults.
(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)
        (internal-border-width . 0)
        (background-color . "#282828") ; gruvbox, until the theme loads
        (foreground-color . "#ebdbb2")))
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil
      frame-inhibit-implied-resize t
      frame-resize-pixelwise t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      initial-scratch-message nil
      use-dialog-box nil
      use-file-dialog nil)

;;; early-init.el ends here
