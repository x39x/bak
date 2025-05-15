;;; -*- lexical-binding: t; no-byte-compile: t; -*-

;; startup

(setq package-enable-at-startup nil
      load-prefer-newer t
      inhibit-startup-screen t)

(add-hook 'after-init-hook #'(lambda ()
                               (interactive)
                               (require 'server)
                               (or (server-running-p)
                                   (server-start))))

;; straight+use-package
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-vc-git-default-clone-depth 1)
(straight-use-package 'use-package)
(setq use-package-compute-statistics t)


;; performance
;; https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq gc-cons-threshold 100000000
      read-process-output-max (* 1024 1024))

;; https://www.masteringemacs.org/article/speed-up-emacs-libjansson-native-elisp-compilation
(if (and (fboundp 'native-comp-available-p)
         (native-comp-available-p))
    (setq comp-deferred-compilation t
          package-native-compile t)
  (message "Native complation is *not* available, lsp performance will suffer..."))

(unless (functionp 'json-serialize)
  (message "Native JSON is *not* available, lsp performance will suffer..."))

; do not steal focus while doing async compilations
(setq warning-suppress-types '((comp)))



(setq init-file '(
                       init-defaults
                       init-ui
                       init-vertico
                       init-edit
                       init-magit
                       init-eglot
                       init-flymake
                       init-company
                       init-python
                       init-rust
                       init-go
                       init-c
                       projectile
                       ))
(add-to-list 'load-path (concat user-emacs-directory "lisp"))

(dolist (layer init-file)
  (require layer))


;; init.el ends here
