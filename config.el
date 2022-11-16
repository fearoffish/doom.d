;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jamie van Dyke"
      user-mail-address "me@fearof.fish")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Fira Code Retina" :size 15)
     doom-variable-pitch-font (font-spec :family "Fira Code Retina" :size 15)
     line-spacing 2)
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-vibrant)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; Implicit /g flag on evil ex substitution, because I use the default behavior
;; less often.
(setq evil-ex-substitute-global t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Resizable treemacs in follow mode
(setq treemacs-width 50
      treemacs--width-is-locked nil
      treemacs-width-is-initially-locked nil)

(customize-set-variable 'copilot-enable-predicates '(evil-insert-state-p))

; complete by copilot first, then company-mode
(defun my-tab ()
  (interactive)
  (or (copilot-accept-completion)
      (company-indent-or-complete-common nil)))

; modify company-mode behaviors
(with-eval-after-load 'company
  ; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends)
  ; enable tab completion
  (define-key company-mode-map (kbd "<tab>") 'my-tab)
  (define-key company-mode-map (kbd "TAB") 'my-tab)
  (define-key company-active-map (kbd "<tab>") 'my-tab)
  (define-key company-active-map (kbd "TAB") 'my-tab))

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-h" . 'copilot-accept-completion-by-word)
         ("C-h" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("C-j" . 'copilot-accept-completion)
         ("C-j" . 'copilot-accept-completion)))

(setq
 projectile-project-search-path '("~/SAPDevelop" "~/a"))

(cond (IS-MAC
       (setq mac-command-modifier       'meta
             mac-option-modifier        'alt
             mac-right-option-modifier  'alt
             mac-pass-control-to-system nil)))

;; unbind right alt from emacs so I can use UK symbols
(setq ns-right-alternate-modifier (quote none))

(setq confirm-kill-emacs nil)

(setq initial-frame-alist '((top . 1) (left . 1) (width . 281) (height . 71)))

;; keybind to disable search highlighting (like :set noh)
(map! :leader
      :desc "Clear search highlight"
      "s c"
      #'evil-ex-nohighlight)

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Emacs LSP on Rust file is nightmare
(after! rustic
  (setq rustic-lsp-client nil))

;; It is 21st century, should I save file manually?
;; (use-package! super-save
;;   :config
;;   (add-to-list 'super-save-triggers 'vertico)
;;   (add-to-list 'super-save-triggers 'magit)
;;   (add-to-list 'super-save-triggers 'find-file)
;;   (add-to-list 'super-save-triggers 'winner-undo)

;;   ;; Need to explicitly load the mode
;;   (super-save-mode +1))

;; `hl-line-mode' breaks rainbow-mode when activated together
(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))

;;;;
;;; UI

(setq doom-theme 'doom-dark+)

;; Prevents some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;;
;; I don't like working with Emacs internal keyring
(define-key evil-normal-state-map "x" 'delete-forward-char); delete to the black hole
(define-key evil-normal-state-map "X" 'delete-backward-char)

(defun meain/evil-delete-advice (orig-fn beg end &optional type _ &rest args)
    "Make d, c, x to not write to clipboard."
    (apply orig-fn beg end type ?_ args))

;; (advice-add 'evil-delete :around 'meain/evil-delete-advice)
;; (advice-add 'evil-change :around 'meain/evil-delete-advice)

;;
;;; Keybindings

;; Until the related PR merged, I neeed to configure colemak binding manually
;; https://github.com/hlissner/doom-emacs/issues/783
;; (use-package! evil-colemak-basics
;;   :after evil
;;   :init
;;   (setq evil-colemak-basics-layout-mod `mod-dh)
;;   :config
;;   (global-evil-colemak-basics-mode))

;; Ruby + RSpec
(after! projectile
  (projectile-register-project-type 'ruby-rspec '("Gemfile" "lib" "spec")
                                    :project-file "Gemfile"
                                    :compile "bundle exec rake"
                                    :src-dir "lib/"
                                    :test "bundle exec rspec"
                                    :test-dir "spec/"
                                    :test-suffix "_spec")

  (defun projectile-test-suffix (project-type)
    "Find default test files suffix based on PROJECT-TYPE."
    (cond
     ((member project-type '(emacs-cask)) "-test")
     ((member project-type '(rails-rspec ruby-rspec)) "_spec")
     ((member project-type '(rails-test ruby-test lein-test boot-clj go)) "_test")
     ((member project-type '(scons)) "test")
     ((member project-type '(npm)) ".spec")
     ((member project-type '(maven symfony)) "Test")
     ((member project-type '(gradle gradlew grails)) "Spec"))))
