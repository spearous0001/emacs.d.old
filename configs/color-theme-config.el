;; ----------------------------- color theme ----------------------------------
;; 配色方案。通过M-x color-theme-select打开一个配色方案选择窗口，在配色方案上按l（小写的L）
;; 就可以改变当前frame的配色，按i就可以改变所有frame的配色。
;; 如果想选定一个配色方案后就一直使用它，可以按p把当前的配色方案的lisp打印出来，然后加到.emacs
;; 文件；此时，就不需要使用(require 'color-theme)了。
;; 注：在GNU Emacs下，有个plist-to-alist错误（在color-theme.el————本配置使用的是第6.5.0
;;    版本————文件的261行），对于源文件，该行已经注释掉了。如在XEmacs中遇到plist错误，请取消
;;    该注释。

(setq load-path (cons "~/.emacs.d/lisps/color-theme/" load-path))
(load "color-theme")

;;(require 'color-theme)
;; use xterm
;;(color-theme-arjen)
;;(color-theme-billw)
;;(color-theme-tty-dark)
;;(color-theme-euphoria)
;;(color-theme-snow)
;;(color-theme-scintilla) ;; OK
;;(color-theme-midnight) ;; OK-1
;;(color-theme-katester) ;; OK-0
;;(color-theme-high-contrast)
;;(color-theme-gray1)
;;(color-theme-dark-laptop)

;; use X Window 
;;(color-theme-gnome2)
