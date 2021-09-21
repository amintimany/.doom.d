;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Amin Timany"
      user-mail-address "amintimany@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-spectrum)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; ---------------------------------------------------------

(load! "coq" doom-private-dir)

;; ---------------------------------------------------------

;;  Delete selected text and replace it
(delete-selection-mode 1)

;; Set locale
(setenv "LANG" "en_US.UTF-8")
;; Adjust the default font size
(defun adjust-font-size ()
  "Set the font hieght as 0.1 (x-display-pixel-height)"
  (progn
    (set-face-attribute 'default nil :height (floor (* (x-display-pixel-height) 0.1)))
    (setq doom-modeline-height 25)))

(when (display-graphic-p)
  (adjust-font-size))

;; Force emacs ask yes no question when exiting
;; (setq confirm-kill-emacs 'y-or-n-p)

;; start Emacs in 120*50 characters
(setq initial-frame-alist '((width . 120) (height . 50)))

;;  git-gutter-mode
(global-git-gutter-mode +1)

;;  sml-modeline-mode
(sml-modeline-mode t)

;; Agda-input-mode
(defun enable-agda-input () (interactive) (progn (require 'agda-input) (set-input-method "Agda")))

;; column enforce mode
(require 'column-enforce-mode)
(setq column-enforce-column 100)

;; configuring auctex
(after! tex
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (setq reftex-plug-into-AUCTeX t)
  (setq TeX-PDF-mode t)
  (setq TeX-source-correlate-method (quote synctex))
  (setq TeX-source-correlate-mode t)
  (setq-default TeX-master t)

  (setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
  (setq TeX-view-program-list
        '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -r %n %o %b"))))

;; Coq and ProofGeneral
(add-hook 'coq-mode-hook 'column-enforce-mode)

(setq coq-double-hit-enable t)

;; Load company-coq when opening Coq files
(add-hook 'coq-mode-hook 'company-coq-mode)
;; Disable symbol prettification
(after! company-coq (setq company-coq-disabled-features '(prettify-symbols)))

(add-hook 'coq-mode-hook 'enable-agda-input)

;;------------------------------------------------------------------------------
;; Bind C-c C-- to toggling comments.

(defun comment-or-uncomment-line-or-region ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    )
  )

(global-set-key (kbd "C-c C--") 'comment-or-uncomment-line-or-region)

;; If aspell is leaded, map mouse clicks. We can't (easily) do a mouse-2 without
;; an actual mouse!
(eval-after-load "flyspell"
  '(progn
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)))


;;------------------------------------------------------------------------------
;; ivy and counsel
(after! (:and ivy counsel)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "C-h f") 'counsel-describe-function)
  (global-set-key (kbd "C-h v") 'counsel-describe-variable)
  (global-set-key (kbd "C-h l") 'counsel-find-library)
  (global-set-key (kbd "C-h i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "C-h u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

  (setq counsel-find-file-ignore-regexp "\\.vo\\|\\.aux\\|\\.glob\\|.DS_STORE"))

(after! evil-maps
  (define-key evil-motion-state-map "\\" nil)
  (define-key evil-motion-state-map (kbd "C-o") 'evil-execute-in-emacs-state)
  (define-key evil-insert-state-map (kbd "C-p") nil)
  (define-key evil-insert-state-map (kbd "C-n") nil))
