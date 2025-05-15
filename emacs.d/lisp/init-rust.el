;;; -*- lexical-binding: t; no-byte-compile: t; -*-

;; expects: rust-analyzer
;; usage: https://github.com/rust-lang/rust-mode

(use-package rust-mode
  :straight t
  :defer t
  :init
  (when (executable-find "rust-analyzer")
    (add-hook 'rust-mode-hook 'eglot-ensure)))

(provide 'init-rust)
