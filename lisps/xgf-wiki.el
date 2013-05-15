;;(require 'emacs-wiki)
(load "xgf-emacs-wiki")
(add-hook 'emacs-wiki-mode-hook
	  (lambda ()
	    (define-key emacs-wiki-mode-map (kbd "C-c C-h") 
              'emacs-wiki-preview-html)
	    (define-key emacs-wiki-mode-map (kbd "C-c C-c") 
              'emacs-wiki-preview-source)
	    (define-key emacs-wiki-mode-map (kbd "C-c C-v") 
              'emacs-wiki-change-project)))

(setq emacs-wiki-grep-command "glimpse -nyi \"%W\"")
(setq emacs-wiki-publishing-directory "publish")
(setq emacs-wiki-directories '("~/WiKi"))
(setq emacs-wiki-meta-charset "gb2312")
(setq emacs-wiki-style-sheet "")
(setq emacs-wiki-inline-relative-to 'emacs-wiki-publishing-directory)

(defun emacs-wiki-preview-source ()
  (interactive)
  (emacs-wiki-publish-this-page)
  (find-file (emacs-wiki-published-file)))

(defun emacs-wiki-preview-html ()
  (interactive)
  (emacs-wiki-publish-this-page)
  (browse-url (emacs-wiki-published-file)))

(setq emacs-wiki-projects
      `(("default" . ((emacs-wiki-directories . ("~/WiKi"))))
        ("work" . ((fill-column . 65)
                   (emacs-wiki-directories . ("~/workwiki/"))))))
