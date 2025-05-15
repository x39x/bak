;;; -*- lexical-binding: t; no-byte-compile: t; -*-

;; expects: hls
;; usage: https://github.com/haskell/haskell-mode

(use-package haskell-mode
  :straight t
  :defer t
  :init
  (when (executable-find "haskell-language-server-wrapper")
    (add-hook 'haskell-mode-hook 'eglot-ensure))
  )

(provide 'init-haskell)
