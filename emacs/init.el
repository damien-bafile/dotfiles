;; init.el --- Emacs init file -*- lexical-binding: t -*-

;; Suppress byte-compiler noise from third-party packages
(setq byte-compile-warnings '(not docstrings docstrings-control-chars
                                  obsolete noruntime make-local))

;; Straight.el bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Load new Org IMMEDIATELY before org-babel-load-file triggers the built-in version
(straight-use-package 'org)
(require 'org)

;; Fix for magit transient dependency
(straight-use-package 'transient)
(require 'transient)

;; Prevent "Wrong type argument: bufferp" error from delayed warnings
(defun display-delayed-warnings-safe (&rest args)
  "Wrap display-delayed-warnings to prevent bufferp errors."
  (ignore-errors
    (apply args)))
(advice-add 'display-delayed-warnings :around #'display-delayed-warnings-safe)

;; Pin Magit version: straight's build dir isn't a git repo, so Magit
;; cannot auto-detect its version and warns on every startup.
;; Update this if you run straight-pull-all / rebuild Magit.
(setq magit-version "v4.7.2-6-g5e21bac5")

;; Now it's safe to load the literate config
(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ignored-local-variable-values
   '((eval progn (setq-local lsp-diagnostics-mode nil)
	   (when (bound-and-true-p lsp-mode) (lsp-mode -1))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
