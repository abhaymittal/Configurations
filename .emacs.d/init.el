;;; init.el --- Bootstrap straight.el + use-package, then load config.org -*- lexical-binding: t; -*-

;; --- Disable package.el (we use straight.el instead) -----------------------
(setq package-enable-at-startup nil)

;; --- Bootstrap straight.el -------------------------------------------------
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir) user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; --- use-package via straight ---------------------------------------------
(straight-use-package 'use-package)
(setq straight-use-package-by-default t
      use-package-always-defer       t
      use-package-expand-minimally   t)

;; --- Tangle and load config.org -------------------------------------------
(require 'org)
(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory))

;; init.el ends here
