;;; -*- lexical-binding: t; no-byte-compile: t; -*-

;; utf-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(global-eldoc-mode 1) ; eglot uses this too
(electric-pair-mode 1) ; auto parens in pairs
(add-hook 'before-save-hook 'whitespace-cleanup) ; auto strip whitespace
(delete-selection-mode) ; allow highlight and backspace over text like a normal editor

;; clean look
(blink-cursor-mode -1)
(scroll-bar-mode -1)
(fringe-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq-default
 frame-resize-pixelwise t ; support better certain window managers like ratpoison

 ;; these settings still should be set on a per language basis, this is just a general default
 indent-tabs-mode nil ; spaces > tabs
 tab-width 8 ; tab is 8 spaces
 fill-column 80 ; python friendly, almost. HAHAHA

 ;; better security
 gnutls-verify-error t
 gnutls-min-prime-bits 2048

 ;; dont expire a passphrase
 password-cache-expiry nil

 mouse-yank-at-point t
 save-interprogram-paste-before-kill t
 apropos-do-all t
 require-final-newline t
 ediff-window-setup-function 'ediff-setup-windows-plain

 tramp-default-method "ssh"
 tramp-copy-size-limit nil

 vc-follow-symlinks t ; open symlinks, don't ask confusing questions

 ring-bell-function 'ignore ; be quiet

 browse-url-browser-function 'eww-browse-url ; use a text browser --great for clicking documentation links
 )

(setq backup-directory-alist
       `((".*" . ,temporary-file-directory)))
 (setq auto-save-file-name-transforms
       `((".*" ,temporary-file-directory t)))

(defalias 'yes-or-no-p 'y-or-n-p) ; don't make us spell "yes" or "no"

;; better dired
(add-hook 'dired-load-hook (function (lambda () (load "dired-x"))))


;; TAB is indent or auto completion
(setq tab-always-indent 'complete)


;; scrolling line by line
(setq scroll-conservatively most-positive-fixnum)
;; nicer scrolling
(when (>=  emacs-major-version 29)
  (pixel-scroll-precision-mode 1))
(or (display-graphic-p)
    (progn
      (xterm-mouse-mode 1)))


;; line num
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
;; Font settings
(set-face-attribute 'default nil :family "IosevkaTerm Nerd Font Mono" :height 160)
;; notification in minibuffer no wrap 
(setq message-truncate-lines t)

(provide 'init-defaults)
