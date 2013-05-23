
;;;; 各种模式（mode）设置

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;;{{{ Menu ;;;;
(if (boundp 'vc-menu-map)
    (add-to-list 'minor-mode-map-alist
                 `(vc-mode keymap
                           (menu-bar keymap
                                     (VC menu-item "VC" ,vc-menu-map)))))

(define-key-after menu-bar-tools-menu [server-start]
  ;;'("(重新)启动server" . server-start) t)
  '("(Re)start Server" . server-start) t)


(defun my-menu-bar-find-file (file doc help)
  "Make a menu-item to visit a file read-only.
FILE is the file to visit, relative to `data-directory'.
DOC is the text to use the menu entry.
HELP is the text to use for the tooltip."
  `(menu-item ,doc
              (lambda () (interactive)
                (find-file-read-only
                 (expand-file-name ,file data-directory)))
              :help ,help))


(let ((last 'emacs-problems)           ; start point in menu
      file doc this)
  (mapcar (lambda (elem)
            (setq file (car elem)
                  doc (cdr elem)
                  ;; NB how make symbol on the fly. Not `make-symbol'.
                  this (intern (concat "emacs-" (downcase file))))
            (define-key-after menu-bar-help-menu `[,this]
              (my-menu-bar-find-file file doc doc)
              last)
            (setq last this))
     ;;'(("TODO"       . "Emacs的TODO")
     ;;       ("DEBUG"      . "Emacs调试信息")
     ;;       ("JOKES"      . "Emacs笑话")
     ;;       ("future-bug" . "Emacs未来的bug"))))
        '(("TODO"       . "Emacs TODO List")
        ("DEBUG"      . "Emacs Debugging Information")
        ("JOKES"      . "Emacs Jokes")
        ("future-bug" . "Emacs Future Bug"))))


;; cf menu-bar-make-mm-toggle.
(defmacro my-menu-bar-make-local-mm-toggle (fname doc help &optional props)
  "Make a menu-item for a local minor mode toggle.
FNAME is the minor mode's name (variable and function).
DOC is the text to use the menu entry.
HELP is the text to use for the tooltip.
PROPS are additional properties."
  `'(menu-item ,doc ,fname
          ,@(if props props)
          :help ,help
          :button (:toggle . (and (boundp ',fname)
                   ,fname))))


(or (fboundp 'menu-bar-make-mm-toggle)  ; for 21.3
    (defmacro menu-bar-make-mm-toggle (fname doc help &optional props) ""
      `'(menu-item ,doc ,fname
         ,@(if props props)
         :help ,help
         :button (:toggle . (and (default-boundp ',fname)
                  (default-value ',fname))))))


(when (boundp 'menu-bar-options-menu)
  ;; Note that an error in a definition of this kind caused Emacs to exit
  ;; after "loading tooltip" portion of startup.
  (define-key-after menu-bar-options-menu [show-trailing-whitespace]
    (my-menu-bar-make-local-mm-toggle
     show-trailing-whitespace
     ;; "高亮句子结尾的空格"
     ;; "高亮句子结尾的空格(显示结尾的空白)")
     "Trailing Whitespace Highlighting"
     "Highlight whitespace at line ends (Show Trailing Whitespace)")
    'highlight-paren-mode)


  (define-key-after menu-bar-options-menu [toggle-auto-image]
    (menu-bar-make-mm-toggle auto-image-file-mode
      ;; "自动显示图片文件"
      ;; "以查看图片的方式显示图片")
      "Automatic Display of Image Files"
      "Visit image files as images")
      'toggle-auto-compression)

  (define-key-after menu-bar-options-menu [debug-on-signal]
    (menu-bar-make-toggle
      toggle-debug-on-signal debug-on-signal
      ;; "以信号的方式进入Debugger" "在 %s 信号上调试"
      ;; "不管条件处理模式,进入Lisp的调试模式")
      "Enter Debugger on Signal" "Debug on Signal %s"
      "Enter Lisp debugger regardless of condition handlers")
      'debug-on-error)

  (if (boundp 'menu-bar-showhide-menu)
    (define-key menu-bar-showhide-menu [ruler]
      (my-menu-bar-make-local-mm-toggle ruler-mode
        ;; "Ruler" "ruler显示/不显示"))
        "Ruler" "Turn ruler on/off"))

    (define-key-after menu-bar-options-menu [tool-bar-separator]
      '("--") 'debug-on-quit)

    (define-key-after menu-bar-options-menu [tool-bar]
      (menu-bar-make-mm-toggle tool-bar-mode 
        ;; "收起工具条"
        ;; "切换工具条的显示")
        "Toggle Tool Bar"
        "Toggle display of the tool-bar")
        'tool-bar-separator)

    (define-key-after menu-bar-options-menu [display-time]
      (menu-bar-make-mm-toggle
        display-time-mode 
        ;; "切换显示 时间/邮件"
        ;; "切换显示 时间/邮件 的指示器"))))
        "Toggle Display Time/Mail"
        "Toggle display of the time and mail indicator"))))

;;}}} Menu ;;;;


;;{{{ Font-lock ;;;;
;;;
;;启动语法高亮模式
(global-font-lock-mode t)

;;使用gdb的图形模式
(setq gdb-many-windows t)
;;(global-font-lock-mode 1)

;;该部分从别的地方直接拷贝过来，============= 待仔细查看、修改 ===============
(setq font-lock-maximum-decoration t
      ;; Removed text-mode from this exclusion list for 21.
      ;; Otherwise yanking preserves font-lock attributes of kill buffer,
      ;; which is annoying. Still need hook to actually enable
      ;; font-lock mode for text-mode - see below.
      ;; Then put back in as it messes up latex mode as well.
      font-lock-global-modes '(not shell-mode text-mode)
      font-lock-verbose t
      font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000)))


;; Extra highlighting.
(mapcar '(lambda (element)
      (let ((mode (car element))
       (comment (cdr element)))
        (font-lock-add-keywords
         mode
         '((,comment ("\\<\\(GM\\|NB\\|TODO\\|FIXME\\)\\>" nil nil
            (0 'font-lock-warning-face t)))
      (,comment ("[* ]\\*\\([a-zA-Z].*\\)\\*" nil nil
            (1 'font-lock-warning-face t)))
      (,comment ("`\\([^`']+\\)'" nil nil
            (1 'font-lock-constant-face t)))))))
   '((awk-mode      . "#")
     (sh-mode       . "#")
     (fortran-mode  . "^C")
     (f90-mode      . "!")
     (makefile-mode . "#")))


;; Support mode.
;; jit-lock doesn't seem to work for MIME messages in VM.
(setq font-lock-support-mode
      (if (boundp 'jit-lock-mode)
          '((vm-mode . fast-lock-mode) (t . jit-lock-mode))
        'fast-lock-mode))


;; Jit-lock.
(setq jit-lock-stealth-verbose nil
      jit-lock-stealth-time 2

      ;; If system load rises above this value, pause stealth fontification.
      jit-lock-stealth-load 90

      ;; Seconds to pause between chunks of stealth fontification.
      jit-lock-stealth-nice 0.5

      ;; If nil, deferred fontification only on lines directly modified.
      ;; If t, on those line plus any following.
      ;; Any other value, only if syntactic fontification for that buffer.
      jit-lock-defer-contextually 'syntax-driven)


;; Fast-lock. Caches font-lock information to speed up loads.
(setq fast-lock-minimum-size 50000 ; but not for small files
      fast-lock-verbose      50000 ; so keep quiet

      ;; Or kill-buffer, kill-emacs. If did not save, do not care.
      fast-lock-save-events '(save-buffer)
      fast-lock-save-others nil   ; no font-caching for others' files

      ;; Prefer all information to be in one place rather than ./
      fast-lock-cache-directories `(,(expand-file-name "flc" "~/.emacs.d/")))


(mapcar '(lambda (element)
      (let ((dir (if (listp element) (cdr element) element)))
        (or (file-directory-p dir) (make-directory element))))
   fast-lock-cache-directories)
;;;
;;}}} Font-lock ;;;;


;;{{{ 缩写词abbrev mode
;; ensure abbrev mode is always on
(setq-default abbrev-mode t)
;; do not bug me about saving my abbreviations
(setq save-abbrevs nil)
;;}}}


;;{{{ c-mode 的配置，专门为kernel的编程风格做一个模块
;; face
(font-lock-add-keywords
 'c-mode
 `(("/\\*" ("\\<\\(GM\\|NB\\|FIXME\\|TODO\\)\\>"
            nil nil (0 'font-lock-warning-face t)))
   ;; More complex than usual to avoid comments commented by coment-region.
   ("/\\*" ("\\*\\([^ ][^*]*[^ ]*\\)\\*[^//]"
            nil nil (1 'font-lock-warning-face t)))
   ("/\\*" ("`\\([^`']+\\)'" nil nil (1 'font-lock-constant-face t)))
   (,(regexp-opt '("&&" "||" "<=" ">=" "==" "!=" ; overkill?
                   "++" "--" "+=" "-=" "*=" "/=") t) .
                   font-lock-constant-face)))
;; This will define the M-x my-linux-c-mode command.  When hacking on a
;; module, if you put the string -*- linux-c -*- somewhere on the first
;; two lines, this mode will be automatically invoked. Also, you may want
;; to add
;; (add-hook 'c-mode-hook
;;           '(lambda () (hs-minor-mode 1)
;;              (or (file-expand-wildcards "[Mm]akefile")
;;                  (set (make-local-variable 'compile-command)
;;                       (format "gcc %s" buffer-file-name)))))

;; (setq auto-mode-alist (cons '("/usr/src/linux.*/.*\\.[ch]$" . my-linux-c-mode)
;;                             auto-mode-alist))
;; (setq auto-mode-alist (cons '("/home/jerry/linux.*/.*\\.[ch]$" . my-linux-c-mode)
;;                             auto-mode-alist))


;; 我的linux的kernel的编辑策略
(defun my-linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "k&r")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))


;; FIXME 我的C/C++语言编辑策略
(defun my-c-mode-common-hook()
  ;(c-set-style "k&r")
  (c-set-style "stroustrup")
  ;(setq tab-width 4 indent-tabs-mode t)
  (setq tab-width 4 indent-tabs-mode nil)
;;; hungry-delete and auto-newline
  (c-toggle-auto-hungry-state 1)
  (hs-minor-mode 1)
  (setq abbrev-mode 1)
  
  ;;按键定义
  (define-key c-mode-base-map [(control \`)] 'hs-toggle-hiding)
  (define-key c-mode-base-map [(return)] 'newline-and-indent)
  (define-key c-mode-base-map [(f7)] 'compile)
  (define-key c-mode-base-map [(f8)] 'ff-get-other-file)
  (define-key c-mode-base-map [(meta \`)] 'c-indent-command)
  ;;  (define-key c-mode-base-map [(tab)] 'hippie-expand)
  (define-key c-mode-base-map [(tab)] 'my-indent-or-complete)
  (define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
  
  ;;预处理设置
  (setq c-macro-shrink-window-flag t)
  (setq c-macro-preprocessor "cpp")
  (setq c-macro-cppflags " ")
  (setq c-macro-prompt-flag t)
  ;; (require 'xcscope)
  ;;   ;;显示C的typedef
  ;;   (require 'ctypes)
  ;;   (ctypes-auto-parse-mode 1)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c-mode-hook 'imenu-add-menubar-index)

;; (defun my-ctypes-load-hook ()
;;   (ctypes-read-file "~/.ctypes_std_c" nil t t))
;; (add-hook 'ctypes-load-hook 'my-ctypes-load-hook)

;;;;我的C++语言编辑策略
(defun my-c++-mode-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  ;; (require 'xcscope)
  ;;   ;;显示C的typedef
  ;;   (require 'ctypes)
  ;;   (ctypes-auto-parse-mode 1)
  (c-set-style "stroustrup")
  ;;  (define-key c++-mode-map [f3] 'replace-regexp)
  )

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;;;;C/C++语言启动时自动加载semantic对/usr/include的索引数据库
(setq semanticdb-search-system-databases t)
(add-hook 'c-mode-common-hook
          (lambda ()
        (setq semanticdb-project-system-databases
         (list (semanticdb-create-database
           semanticdb-new-database-class
           "/usr/include")))))
;;}}} c mode


;;{{{ 我的Java语言编辑策略
(defun my-java-mode-hook()
  (setq tab-width 4 indent-tabs-mode nil))
(add-hook 'java-mode-hook 'my-java-mode-hook)
;;}}}


;;{{{ Python Mode设置
(add-to-list 'load-path "~/.emacs.d/lisps/python-mode/")
(add-to-list 'load-path "~/.emacs.d/lisps/python-mode/completion/")
(add-to-list 'load-path "~/.emacs.d/lisps/python-mode/test/")
(add-to-list 'load-path "~/.emacs.d/lisps/python-mode/extensions/")
(setq py-install-directory "~/.emacs.d/lisps/python-mode/")
(require 'python-mode)
(require 'doctest-mode)
(require 'highlight-indentation)

(require 'column-marker)
(add-hook 'foo-mode-hook (lambda () (interactive) (column-marker-1 80)))
(global-set-key [?\C-c ?m] 'column-marker-1)

(require 'py-smart-operator)
;; `M-x smart-operator-mode' for toggling this minor mode.
(py-smart-operator-mode t)

;;(require 'pycomplete)
(setq py-load-pymacs-p t)
;;;
;;}}}


;;{{{ 注释配置
;; (load-file "/home/jerry/lib/emacs-lisp/gnome-doc.el")
;;}}}


;;{{{ makefile-mode ;;;;
(add-hook 'makefile-mode-hook 'imenu-add-menubar-index)
;;}}} makefile-mode ;;;;


;;{{{ Lisp-mode ;;;;
;; 增加一些常用的高亮颜色
(font-lock-add-keywords
 'emacs-lisp-mode
 '((";" ("\\<\\(GM\\|NB\\|TODO\\|FIXME\\)\\>"  nil nil
         (0 'font-lock-warning-face t)))
   (";" ("[* ]\\*[ \t]*\\(\\w.*\\)\\*" nil nil
         (1 'font-lock-warning-face t)))))


;; (mapcar (function (lambda (elem)
;;                     (add-hook 'emacs-lisp-mode-hook elem)))
;;         '(imenu-add-menubar-index turn-on-eldoc-mode))
;;               ;; checkdoc-minor-mode))

;; lisp 开发用的
(defun my-emacs-lisp-mode-hook-fn ()
  "Function added to `emacs-lisp-mode-hook'."
  (local-set-key "\C-cd" 'my-jump-to-defun)
  ;;(hs-minor-mode 1)
  ;; A little shorter than "Emacs-Lisp".
  ;; Avoid lisp-interaction and other derived modes.
  (if (eq major-mode 'emacs-lisp-mode)
      (setq mode-name "Elisp"))
  (when (boundp 'comment-auto-fill-only-comments)
    (setq comment-auto-fill-only-comments t)
    (kill-local-variable 'normal-auto-fill-function)))

(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook-fn)

(defun my-lisp-interaction-mode-hook-fn ()
  "Function added to `lisp-interaction-mode-hook'."
  (setq mode-name "Lisp Int"))
(add-hook 'lisp-interaction-mode-hook 'my-lisp-interaction-mode-hook-fn)

(setq eval-expression-print-level  10
      eval-expression-print-length 100)
;;;
;;}}} Lisp-mode ;;;;


;;{{{ WoMan ;;;;
(setq
 woman-cache-filename (expand-file-name "woman.cache" "~/.emacs.d/")
 woman-bold-headings nil
 woman-imenu-title "WoMan-imenu"
 woman-imenu t
 woman-use-own-frame nil      ;不使用单独的frame
 woman-use-topic-at-point nil
 woman-fill-frame nil
 woman-show-log nil)

;;配置一下woman的颜色设置
(defun my-woman-pre-format-fn ()
  "."
  (face-spec-set 'woman-bold-face '((t (:foreground "white" :weight normal))))
  (face-spec-set 'woman-italic-face   '((t (:foreground "yellow"))))
  (face-spec-set 'woman-addition-face '((t (:foreground "orange"))))
  (face-spec-set 'woman-unknown-face  '((t (:foreground "cyan"))))
  ;; TODO can a function know its name?
  (remove-hook 'woman-pre-format-hook 'my-woman-pre-format-fn))

(add-hook 'woman-pre-format-hook 'my-woman-pre-format-fn)

;; So that each instance will pop up a new frame.
;; Maybe `special-display-regexps' would be better?
(add-hook 'woman-post-format-hook (lambda () (setq woman-frame nil)))
;;;
;;}}} WoMan ;;;;


;;{{{ eshell ;;;;
(defface my-eshell-code-face
  '((t (:foreground "Green")))
  "Eshell face for code (.c, .f90 etc) files.")

(defface my-eshell-img-face
  '((t (:foreground "magenta" :weight bold)))
  "Eshell face for image (.jpg etc) files.")

(defface my-eshell-movie-face
  '((t (:foreground "white" :weight bold)))
  "Eshell face for movie (.mpg etc) files.")

(defface my-eshell-music-face
  '((t (:foreground "magenta")))
  "Eshell face for music (.mp3 etc) files.")

(defface my-eshell-ps-face
  '((t (:foreground "cyan")))
  "Eshell face for PostScript (.ps, .pdf etc) files.")

(setq my-eshell-code-list '("f90" "f" "c" "bash" "sh" "csh" "awk" "el")
      my-eshell-img-list
      '("jpg" "jpeg" "png" "gif" "bmp" "ppm" "tga" "xbm" "xpm" "tif" "fli")
      my-eshell-movie-list '("mpg" "avi" "gl" "dl")
      my-eshell-music-list '("mp3" "ogg")
      my-eshell-ps-list    '("ps" "eps" "cps" "pdf")
      eshell-ls-highlight-alist nil)

(let (list face)
  (mapcar (lambda (elem)
            (setq list (car elem)
                  face (cdr elem))
            (add-to-list 'eshell-ls-highlight-alist
                         (cons `(lambda (file attr)
                                  (string-match
                                   (concat "\\." (regexp-opt ,list t) "$")
                                   file))
                               face)))
          '((my-eshell-code-list  . my-eshell-code-face)
            (my-eshell-img-list   . my-eshell-img-face)
            (my-eshell-movie-list . my-eshell-movie-face)
            (my-eshell-music-list . my-eshell-music-face)
            (my-eshell-ps-list    . my-eshell-ps-face))))

(defun my-tidy-pwd (string)
  "Replace leading ~ by $HOME in output of pwd.
Argument STRING pwd."
  (replace-regexp-in-string "^~" (getenv "HOME") string))

(defun my-eshell-prompt-function ()
  "Return the prompt for eshell."
  (format "[%s@%s %s]%s "
          (eshell-user-name)
          (replace-regexp-in-string "\\..*" "" (system-name))
          (eshell/basename (eshell/pwd))
          (if (zerop (user-uid)) "#" "$")))

(defun my-eshell-line-discard ()
  "Eshell implementation of C-u."
  (interactive)
  (eshell-bol)
  (kill-line))

(defun my-eshell-clear-buffer ()
  "Eshell clear buffer."
  (interactive)
  (let ((eshell-buffer-maximum-lines 0))
    (eshell-truncate-buffer)))

(defalias 'eshell/clear 'my-eshell-clear-buffer)

(setq eshell-directory-name (expand-file-name "eshell" "~/.emacs.d/")
      eshell-pwd-convert-function 'my-tidy-pwd
      eshell-prompt-function 'my-eshell-prompt-function
      eshell-prompt-regexp "^\\[.*\\][#$] "
      eshell-ask-to-save-history 'always
      eshell-banner-message `(format-time-string
                              "Eshell startup: %T, %A %d %B %Y\n\n"))

(defun my-eshell-first-time-mode-hook-fn ()
  "Function added to `eshell-first-time-mode-hook'."
  (face-spec-set 'eshell-ls-backup-face '((t(:foreground "Goldenrod"))))
  (face-spec-set 'eshell-ls-archive-face '((t(:foreground "red" :weight bold))))
  (face-spec-set 'eshell-ls-missing-face '((t(:foreground "orchid"))))
  (define-key eshell-mode-map "\C-ca" 'eshell-bol)
  (define-key eshell-mode-map "\C-c\C-u" 'my-eshell-line-discard)
  (mapcar (lambda (elem)
            (add-to-list 'eshell-visual-commands elem))
          '("pico" "nano")))

(add-hook 'eshell-first-time-mode-hook 'my-eshell-first-time-mode-hook-fn)
;;;
;;}}} eshell ;;;;


;;{{{ Shell-mode ;;;;
;;; Prefer terminal-mode really. Eshell even better.
(setq explicit-shell-file-name "bash"
;;;      shell-file-name "/bin/bash"
      ;; Auto-generated variable name.
      explicit-bash-args '("--login")
      comint-scroll-to-bottom-on-input t
      comint-scroll-show-maximum-output t
      comint-scroll-to-bottom-on-output 'all
      comint-input-ignoredups t   ; 1 copy only of identical input
      comint-completion-autolist t
      comint-completion-addsuffix t
      comint-buffer-maximum-size 200    ; lines
      comint-highlight-input nil  ; highlight previous input
      comint-highlight-prompt nil)

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun my-shell-mode-hook-fn ()
  "Function added to `shell-mode-hook'."
  ;; M-p by default.
  (define-key shell-mode-map [up] 'comint-previous-input)
  ;; M-n by default.
  (define-key shell-mode-map [down] 'comint-next-input)
  (define-key shell-mode-map [backspace] 'my-shell-backspace))

(add-hook 'shell-mode-hook 'my-shell-mode-hook-fn)

;; Passing with lambda expression not liked.
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)
;;;
;;}}} Shell-mode ;;;;


;;{{{ 对相应的文件设定相应的模式，以便正确的语法显亮
;;文件名用正则表达式表示，注意不要后面覆盖了前面的而引起的误会
;;修改这个之前先C-h v auto-mode-alist查查已有的设置
;;一个简单的办法设置 auto-mode-alist, 免得写很多 add-to-list
(mapcar
 (function (lambda (setting)
        (setq auto-mode-alist
         (cons setting auto-mode-alist))))
 '(
   ("\\.\\(xml\\|rdf\\)\\'" . sgml-mode)
   ("\\.\\([ps]?html?\\|cfm\\|asp\\)\\'" . html-helper-mode)
   ("\\.html$" . html-helper-mode)
   ("\\.css\\'" . css-mode)
   ("\\.\\(emacs\\|el\\|session\\|gnus\\)\\'" . emacs-lisp-mode)
   ("\\.wiki\\'" . emacs-wiki-mode)
   ("\\.\\(jl\\|sawfishrc\\)\\'" . sawfish-mode)
   ("\\.scm\\'" . scheme-mode)
   ("\\.py\\'" . python-mode)
   ("\\.\\(ba\\)?sh\\'" . sh-mode)
   ("\\.l\\'" . c-mode)
   ("\\.max\\'" . maxima-mode)
   ;;("\\config" . fvwm-mode)
   ("\\.fvwm2rc$" . fvwm-mode)
   ("\\.fvwmrc$" . fvwm-mode)
   ("\\.strokes$" . fvwm-mode)
   ("\\.conkyrc$" . fvwm-mode)
   ))
;;;
;;}}}auto-list-mode

(provide 'mode-config)

