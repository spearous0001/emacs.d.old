;;; functions.el ---- some small function finishing some small function.

;;{{{
;; 如果你正在编辑一个东西（在位置A），突然想到别的某处（位置B）要修改或查看或
;; 别的，总之你要过去看看，你可以用C-.来在当前位置做个标记，然后去你想去的地方
;; B，看了一会你觉的我可以回A去了，用C-,就回到刚才做标记的地方A，再用C-,又会回
;; 到B。这个由王垠创作。
(global-set-key [(control ?.)] 'my-point-to-register)
(global-set-key [(control ?\,)] 'my-jump-to-register)
(defun my-point-to-register()
  "Store cursorposition _fast_ in a register.
  Use my-jump-to-register to jump back to the stored
  position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun my-jump-to-register()
  "Switches between current cursorposition and position
  that was stored with my-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
    (jump-to-register 8)
    (set-register 8 tmp)))
;;}}}


;;{{{ 
;; 使用%就可以上下翻动匹配的括号；如果没有括号就输入%，类似VIM中的%键。
;; 这个由王垠创作。
(global-set-key "%" 'my-match-paren)
(defun my-match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %.
Argument ARG paren."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
   ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
   (t (self-insert-command (or arg 1)))))
;;}}}


;;{{{ forward-go-to-char，类似VIM中的f移动键
(global-set-key [(control ?c) (control ?f)] 'my-forward-go-to-char)
(defun my-forward-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
Typing `my-forward-go-to-char' again will move forwad to the next Nth
occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char)
           char)
    (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))
;;}}}


;; emacs-lisp-mode
;; 1. 再emacs中编译整个目录下的.el文件输入 [Alt]-x 。 当提示输入命令时，输入
;;        byte-force-recompile [Enter] 。
;; 2. 如何再emacs下编译整个目录下的*.el文件两个办法，一是在dired里面用m标记，
;;    然后用B编译还有就是用emacs的批处理：
;;        emacs -batch -f batch-byte-compile *.el
;; 这个忘了是从哪个地方弄来的，在保存~/.emacs文件自动编译为.elc文件；目前只是
;; 对~/.emacs有效，其余的*.el文件还没有去弄，以后有空我会改的小知识：由于配置
;; 文件越来越大，你的*.el配置文件最好都编译为*.elc文件，这样在启动emacs速度会
;; 有很大的提升。
;;
;; (defun autocompile nil
;;   "Compile itself if ~/.emacs."
;;   (interactive)
;;   (if (string= (buffer-file-name) (concat default-directory ".emacs"))
;;       (byte-compile-file (buffer-file-name))))
;; (add-hook 'after-save-hook 'autocompile)
;;
;;{{{  自动编译一个目录下的el文件
;;(defconst dotemacs-basic-conf-dir "~/lib/emacs-lisp/")
;;(defconst dotemacs-ext-elisp-dir "~/.emacs.d/config/ext-elisp/")
;;(defconst dotemacs-program-dir "~/.emacs.d/config/program/")
;;
;;(defun autocompile nil
;;  "Automagically compile change to .emacs and other dotfiles."
;;  (interactive)
;;  (cond ((string= (buffer-file-name) (concat default-directory ".emacs"))
;;               (byte-compile-file (buffer-file-name)))
;;
;;        ((string= (abbreviate-file-name (buffer-file-name))
;;               (concat dotemacs-basic-conf-dir
;;                       (replace-regexp-in-string "\\.el" "" (buffer-name)) ".el"))
;;               (byte-compile-file (buffer-file-name)))
;;
;;   ;;  ((string= (abbreviate-file-name (buffer-file-name))
;;   ;;                (concat dotemacs-ext-elisp-dir
;;   ;;                        (replace-regexp-in-string "\\.el" "" (buffer-name)) ".el"))
;;   ;;                (byte-compile-file (buffer-file-name)))
;;
;;   ;;        ((string= (abbreviate-file-name (buffer-file-name))
;;   ;;                (concat dotemacs-program-dir
;;   ;;                        (replace-regexp-in-string "\\.el" "" (buffer-name)) ".el"))
;;   ;;                (byte-compile-file (buffer-file-name)))
;;        )
;;  )
;;(add-hook 'after-save-hook 'autocompile)
;;
;;}}}


;;{{{ 自定义自动补齐命令，如果在单词中间就补齐，否则就是tab。
(defun my-indent-or-complete ()
  "在单词中间就补齐,否则就tab."
   (interactive)
   (if (looking-at "\\>")
       (hippie-expand nil)
     (indent-for-tab-command))
   )
;;}}}


;;这个是从emacs-lisp-introduction的那个文档拷过来
;;{{{ 功能同word的计算文字数相似，不过这个功能有待完善，对中文不大好使
(defun my-recursive-count-words (region-end)
  "Number of words between point and REGION-END."
  (if (and (< (point) region-end)
      (re-search-forward "\\w+\\W*" region-end t))
    (1+ (my-recursive-count-words region-end))
    0))

(defun my-count-words-region (beginning end)
  "Print number of words in the region. Words are defined as at least one 
word-constituent character followed by at least one character that is not
a word-constituent. The buffer's syntax table determines which characters
these are. Argument BEGINNING region's beginning. Argument END region's end."
  (interactive "r")
  (message "Counting words in region ... ")
  (save-excursion
    (goto-char beginning)
    (let ((count (my-recursive-count-words end)))
      (cond ((zerop count)
        (message
          "The region does NOT have any words."))
       ((= 1 count)
        (message "The region has 1 word."))
       (t
         (message
      "The region has %d words." count))))))

(defun my-count-words-buffer ()
  "Count the number of words in current buffer;
print a message in the minibuffer with the result."
  (interactive)
  (save-excursion
    (let ((count 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
   (forward-word 1)
   (setq count (1+ count)))
      (message "buffer contains %d words." count))))
;;}}}


;;{{{ replace C-u 0 C-l
;; 功能是将当前行设为本页第一行，同终端下的clear命令有点相似
(defun my-line-to-top-of-window ()
  "Move the line point is on to top of window."
  (interactive)
  (recenter 0))
;;}}}


;;{{{ 在文档里插入时间、用户名还有系统的信息
(defun my-stamp (&optional arg)
  "Insert current date, user, and system information.
With optional argument ARG, use \"*Created: -- *\" format."
  (interactive "*P")
  ;; Get this from time-stamp-format somehow?
  (let ((string (format " %s %s on %s "
                        (format-time-string " %04y-%02m-%02d %02H:%02M:%02S")
                        user-login-name
                        system-name)))
    (if arg (setq string (format "*Creation: %s*" string)))
    (if (interactive-p)
        (insert string)
      string)))
;;}}}


;;{{{ 时间戳设置，插入文档内的
(defun my-timestamp ()
  "Insert the \"Time-stamp: <>\" string at point."
  (interactive)
  (if (interactive-p)
      (insert " Time-stamp: <>")
    " Time-stamp: <>"))
;;}}}


;;{{{ 打开.sawfishrc的快捷方式
(defun my-open-dot-sawfishrc ()
  "Open the dot-sawfishrc file."
  (interactive)
  (find-file "~/.sawfishrc")
  )
;;}}}


;;{{{ 打开.emacs的快捷方式
(defun my-open-dot-emacs ()
  "Open the dot-emacs file."
  (interactive)
  (find-file "~/.emacs")
  )
;;}}}

;;{{{ 打开.sawfishrc配置文件
(defun my-open-fvwmconfig ()
  "Open the fvwm's config file."
  (interactive)
  (find-file "~/.fvwm/config")
  ;(find-file "~/.fvwm/fvwm.strokes")
  )
;;}}}


;;{{{ 找到这个buffer里最长的一行，并且到达哪里，很不错的功能
(defun my-longest-line (&optional goto)
  "Find visual length (ie in columns) of longest line in buffer.
If optional argument GOTO is non-nil, go to that line."
  (interactive "p")
  (let ((maxlen 0)
        (line 1)
        len maxline)
    (save-excursion
      (goto-char (point-min))
      (goto-char (line-end-position))
      ;; Not necessarily same as line-end - line-beginning (eg tabs)
      ;; and this function is for visual purposes.
      (setq len (current-column))
      (if (eobp)                        ; 1 line in buffer
          (setq maxlen len
                maxline line)
        (while (zerop (forward-line))
          (goto-char (line-end-position))
          (setq line (1+ line)
                len (current-column))
          (if (> len maxlen)
              (setq maxlen len
                    maxline line)))))
    (if (not (interactive-p))
        maxlen
      (message "最长的一行是第%s行 (%s)" maxline maxlen)
      ;(message "Longest line is line %s (%s)" maxline maxlen)
      (if goto (goto-line maxline)))))
;;}}}


;;{{{ 给 Options 增加一个"去掉文件末尾空白"的菜单
(when (boundp 'show-trailing-whitespace)
  ;; Mode name must be same as mode variable.
  (define-minor-mode show-trailing-whitespace
    "Toggle display of trailing whitespace.
With optional numeric argument ARG, activate trailing whitespace display if
ARG is positive, otherwise deactivate it."
    :init-value nil
    :lighter " WS")

  (defun my-show-trailing-whitespace ()
    "Activate `show-trailing-whitespace' mode."
    (show-trailing-whitespace 1))

  (mapcar (lambda (hook) (add-hook hook 'my-show-trailing-whitespace))
          '(sh-mode-hook emacs-lisp-mode-hook f90-mode-hook
                         fortran-mode-hook awk-mode-hook
                         change-log-mode-hook c-mode-hook c++-mode-hook
                         python-mode-hook)))
;;}}}


;;{{{ TODO 去掉文件尾部的空白,在写文件的时候自动加载
;; Better functions than this exist in Emacs.
(defun my-delete-trailing-whitespace ()
  "Delete all trailing whitespace in buffer.
Return values are suitable for use with `write-file-functions'."
  (condition-case nil
      (progn
        ;; Don't want to do this to mail messages, etc.
        ;; Would an exclude list be better?
        ;; Error was occurring in VM-mode for some reason.
        (when (memq major-mode '(text-mode sh-mode emacs-lisp-mode
                                 f90-mode awk-mode c-mode c++-mode
                                 python-mode))
          (message "Cleaning up whitespace...")
          (delete-trailing-whitespace)
          (message "Cleaning up whitespace...done")
          nil))
    (error (message "Cleaning up whitespace...ERROR")
           t)))

;;Too invasive?
(add-hook (if (boundp 'write-file-functions) 'write-file-functions
       'write-file-hooks) 'my-delete-trailing-whitespace)
;;}}}


;;{{{ 删除一些临时的buffers，少占我的内存
(defvar my-clean-buffers-names
  '("\\*Completions" "\\*Compile-Log" "\\*.*[Oo]utput\\*$"
    "\\*Apropos" "\\*compilation" "\\*Customize" "\\*Calc""\\keywiz-scores"
    "\\*BBDB\\*" "\\*trace of SMTP" "\\*vc" "\\*cvs" "\\*keywiz"
    "\\*WoMan-Log" "\\*tramp" "\\*desktop\\*" ;;"\\*Async Shell Command"
    )
  "List of regexps matching names of buffers to kill.")

(defvar my-clean-buffers-modes
  '(help-mode );Info-mode)
  "List of modes whose buffers will be killed.")

(defun my-clean-buffers ()
  "Kill buffers as per `my-clean-buffer-list' and `my-clean-buffer-modes'."
  (interactive)
  (let (string buffname)
    (mapcar (lambda (buffer)
              (and (setq buffname (buffer-name buffer))
                   (or (catch 'found
                         (mapcar '(lambda (name)
                                    (if (string-match name buffname)
                                        (throw 'found t)))
                                 my-clean-buffers-names)
                         nil)
                       (save-excursion
                         (set-buffer buffname)
                         (catch 'found
                           (mapcar '(lambda (mode)
                                      (if (eq major-mode mode)
                                          (throw 'found t)))
                                   my-clean-buffers-modes)
                           nil)))
                   (kill-buffer buffname)
                   (setq string (concat string
                                        (and string ", ") buffname))))
            (buffer-list))
    ;;(if string (message "清理buffer: %s" string)
    (if string (message "Deleted: %s" string)
       ;;(message "没有多余的buffer"))))
       (message "No buffers deleted"))))
;;}}}


;;{{{ 打印出我的键盘图，很酷吧－全部热键都显示出来，呵呵
(defun my-keytable (arg)
  "Print the key bindings in a tabular form.
Argument ARG Key."
  (interactive "sEnter a modifier string:")
  (with-output-to-temp-buffer "*Key table*"
    (let* ((i 0)
           (keys (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n"
                       "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
                       "<return>" "<down>" "<up>" "<right>" "<left>"
                       "<home>" "<end>" "<f1>" "<f2>" "<f3>" "<f4>" "<f5>"
                       "<f6>" "<f7>" "<f8>" "<f9>" "<f10>" "<f11>" "<f12>"
                       "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
                       "`" "~" "!" "@" "#" "$" "%" "^" "&" "*" "(" ")" "-" "_"
                       "=" "+" "\\" "|" "{" "[" "]" "}" ";" "'" ":" "\""
                       "<" ">" "," "." "/" "?"))
           (n (length keys))
           (modifiers (list "" "C-" "M-" "S-" "M-C-" "S-C-")))
      (or (string= arg "") (setq modifiers (list arg)))
      (setq k (length modifiers))
      (princ (format " %-10.10s |" "Key"))
      (let ((j 0))
        (while (< j k)
          (princ (format " %-50.50s |" (nth j modifiers)))
          (setq j (1+ j))))
      (princ "\n")
      (princ (format "_%-10.10s_|" "__________"))
      (let ((j 0))
        (while (< j k)
          (princ (format "_%-50.50s_|"
                         "__________________________________________________"))
          (setq j (1+ j))))
      (princ "\n")
      (while (< i n)
        (princ (format " %-10.10s |" (nth i keys)))
        (let ((j 0))
          (while (< j k)
            (let* ((binding
                    (key-binding (read-kbd-macro (concat (nth j modifiers)
                                                         (nth i keys)))))
                   (binding-string "_"))
              (when binding
                (if (eq binding 'self-insert-command)
                    (setq binding-string (concat "'" (nth i keys) "'"))
                  (setq binding-string (format "%s" binding))))
              (setq binding-string
                    (substring binding-string 0 (min (length
                                                      binding-string) 48)))
              (princ (format " %-50.50s |" binding-string))
              (setq j (1+ j)))))
        (princ "\n")
        (setq i (1+ i)))
      (princ (format "_%-10.10s_|" "__________"))
      (let ((j 0))
        (while (< j k)
          (princ (format "_%-50.50s_|"
                         "__________________________________________________"))
          (setq j (1+ j))))))
  (delete-window)
  (hscroll-mode)
  (setq truncate-lines t))              ; for emacs 21
;;}}}


;;{{{
;; ;; 调用 stardict 的命令行接口来查辞典
;; ;; 如果选中了 region 就查询 region 的内容，
;; ;; 否则就查询当前光标所在的词
;; (defun kid-star-dict ()
;;   "Serch dict in stardict."
;;   (interactive)
;;   (let ((begin (point-min))
;;         (end (point-max)))
;;     (if mark-active
;;         (setq begin (region-beginning)
;;               end (region-end))
;;       (save-excursion
;;         (backward-word)
;;         (mark-word)
;;         (setq begin (region-beginning)
;;               end (region-end))))
;;     ;; 有时候 stardict 会很慢，所以在回显区显示一点东西
;;     ;; 以免觉得 Emacs 在干什么其他奇怪的事情。
;;     (message "searching for %s ..." (buffer-substring begin end))
;;     (tooltip-show
;;      (shell-command-to-string
;;       (concat "sdcv -n "
;;               (buffer-substring begin end))))))
;;
;; ;; 如果选中了 region 就查询 region 的内容，否则查询当前光标所在的单词
;; ;; 查询结果在一个叫做 *sdcv* 的 buffer 里面显示出来，在这个 buffer 里面
;; ;; 按 q 可以把这个 buffer 放到 buffer 列表末尾，按 d 可以查询单词
;; (defun kid-sdcv-to-buffer ()
;;   "Search dict in region or world."
;; (interactive)
;;   (let ((word (if mark-active
;;                   (buffer-substring-no-properties (region-beginning) (region-end))
;;       (current-word nil t))))
;;     (setq word (read-string (format "Search the dictionary for (default %s): " word)
;;                             nil nil word))
;;     (set-buffer (get-buffer-create "*sdcv*"))
;;     (buffer-disable-undo)
;;     (erase-buffer)
;;     (let ((process (start-process-shell-command "sdcv" "*sdcv*" "sdcv" "-n" word)))
;;       (set-process-sentinel
;;        process
;;        (lambda (process signal)
;;          (when (memq (process-status process) '(exit signal))
;;            (unless (string= (buffer-name) "*sdcv*")
;;              (setq kid-sdcv-window-configuration (current-window-configuration))
;;              (switch-to-buffer-other-window "*sdcv*")
;;              (local-set-key (kbd "d") 'kid-sdcv-to-buffer)
;;              (local-set-key (kbd "q") (lambda ()
;;                                         (interactive)
;;                                         (bury-buffer)
;;                                         (unless (null (cdr (window-list))) ; only one window
;;                                           (delete-window)))))
;;            (goto-char (point-min))))))))
;;}}}


;;{{{ lisp 里快速找到函数
(defvar my-defun-re
  (regexp-opt '("defun" "defsubst" "defmacro" "defadvice") 'paren)
  "Regular expression used to identify a defun.")

(defun my-jump-to-defun (func)
  "Jump to the definition of function FUNC in the current buffer, if found.
Return the position of the defun, or nil if not found."
  (interactive
   ;; From `describe-function'. *NB ?*
   (let ((fn (function-called-at-point)))
     (list (completing-read (if fn
                                (format "Find defun for (default %s): " fn)
                              "Find defun for: ")
                            obarray 'fboundp t nil nil (symbol-name fn)))))
  (let (place)
    (save-excursion
      (goto-char (point-min))
      (if (re-search-forward
           (concat "^[ \t]*(" my-defun-re "[ \t]+"
                   (regexp-quote func) "[ \t]+") (point-max) t)
          (setq place (point))))
    (if (not place)
        (if (interactive-p) (message "No defun found for `%s'" func))
      (when (interactive-p)
        (push-mark)
        (goto-char place)
        (message "Found defun for `%s'" func))
      place)))
;;}}}


;;{{{ 改变 tabbar-buffer-groups-function
;; 原来的 tabbar 强行对你的 buffer进行分组，但是如果你想在你编辑的buffer间切换
;; 而不论它们是什么组，那么似乎没有一个好办法。但是 tabbar 本来提供了一个机制，
;; 让你可以自己确定tab属于哪组，只要修改tabbar-buffer-groups-function 就行了。
;; 这样，我可以把每个 buffer 同时加入它所在的 major mode 的组和一个叫做 
;; "default" 的组，这样我在 default 组里就可以方便的浏览到所有的 buffer了。而
;; 切换到其它组就可以分组浏览。你还可以自行把某些 buffer 分到一组，比如我可以
;; 把 scheme-mode 的 buffer 和 inferer-scheme-mode 的 buffer 分到同一个组。
(setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)

(defun tabbar-buffer-ignore-groups (buffer)
  "Return the list of group names BUFFER belongs to.
Return only one group for each buffer."
  (with-current-buffer (get-buffer buffer)
    (cond
     ((or (get-buffer-process (current-buffer))
          (memq major-mode
                '(comint-mode compilation-mode)))
      '("Process")
      )
     ((member (buffer-name)
              '("*scratch*" "*Messages*"))
      '("Common")
      )
     ((eq major-mode 'dired-mode)
      '("Dired")
      )
     ((memq major-mode
            '(help-mode apropos-mode Info-mode Man-mode))
      '("Help")
      )
     ((memq major-mode
            '(rmail-mode
              rmail-edit-mode vm-summary-mode vm-mode mail-mode
              mh-letter-mode mh-show-mode mh-folder-mode
              gnus-summary-mode message-mode gnus-group-mode
              gnus-article-mode score-mode gnus-browse-killed-mode))
      '("Mail")
      )
     (t
      (list
       "default"  ;; no-grouping
       (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
           mode-name
         (symbol-name major-mode)))
      )
     )))
;;}}}


;;{{{ TODO 让speedbar获得类似ECB的显示效果,把speedbar集成到emacs主窗口里
;(require 'tramp)
;(defconst my-junk-buffer-name "Junk")
;(setq junk-buffer (get-buffer-create my-junk-buffer-name))

;(require 'speedbar)
;(defconst my-speedbar-buffer-name "SPEEDBAR")
;(setq speedbar-buffer (get-buffer-create my-speedbar-buffer-name)
;    speedbar-frame (selected-frame)
;    dframe-attached-frame (selected-frame)
;    speedbar-select-frame-method 'attached
;    speedbar-verbosity-level 0
;    speedbar-last-selected-file nil)
;
;(setq right-window (split-window-horizontally 24))
;(setq left-window (frame-first-window))
;(walk-windows (lambda (w) (setq left-window w)) "nominibuffer" t)
;(set-buffer speedbar-buffer)
;(speedbar-mode)
;(speedbar-reconfigure-keymaps)
;(speedbar-update-contents)
;(speedbar-set-timer 1)
;(set-window-buffer left-window "SPEEDBAR")
;(set-window-dedicated-p left-window t)
;(toggle-read-only)   ; HACK, REQUIRED for Tramp to work ????
;(select-window right-window)
;(defun select-right-window () (select-window right-window))

;;(defun reset-window-config () (interactive)
;(walk-windows (lambda (w) (when (not (or (eq w left-window) (eq w right-window))) (delete-window w))) "nominibuffer" t)
;; )
;(defun reset-window-config () (interactive)
;   (delete-other-windows)
;   (setq right-window (split-window-horizontally 24))
;   (setq left-window (frame-first-window))
;   (set-window-buffer left-window speedbar-buffer)
;   (set-window-dedicated-p left-window t)
;   (select-window right-window)
;   (set-window-dedicated-p right-window nil)
;   (when (eq speedbar-buffer (window-buffer right-window)) (set-window-buffer right-window (next-buffer)))
;   (set-window-dedicated-p right-window nil)
;   )
;(global-set-key "\C-x1" 'reset-window-config)
;;}}}

(provide 'functions)

;;; functions.el ends here


