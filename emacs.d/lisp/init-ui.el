;;; -*- lexical-binding: t; no-byte-compile: t; -*-

;; remove hostname from the GUI titlebar
(setq-default frame-title-format '("Emacs"))

(use-package simple-modeline
  :straight t
  :hook (after-init . simple-modeline-mode))

;(load-theme 'modus-operandi t)
;(setq dashboard-startup-banner 'ascii)
(setq dashboard-center-content t)
(setq dashboard-items '((recents  . 5)))


(use-package dashboard
  :straight t
  :defer t
  :init
  (dashboard-setup-startup-hook))

(provide 'init-ui)
