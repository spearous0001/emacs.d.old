
;; ****************************************************************************
;; ------------------------------- load path ----------------------------------
(setq load-path (cons "~/.emacs.d/" load-path))
(setq load-path (cons "~/.emacs.d/mydot/" load-path))
(setq load-path (cons "~/.emacs.d/site-lisp/" load-path))
(setq load-path (cons "~/.emacs.d/site-lisp/cedet/" load-path))
(setq load-path (cons "~/.emacs.d/site-lisp/ecb/" load-path))
;;(setq load-path (cons "~/.emacs.d/site-lisp/cscope/" load-path))
;;(setq load-path (cons "~/.emacs.d/site-lisp/doxymacs/" load-path))

;; ****************************************************************************
;; ------------------------------ set some information ------------------------
;; 设置个人信息
(setq user-full-name "sangay")
(setq user-full-address "xgfone@gmail.com")

;; 设置书签文件
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk")

;; 设置缩略词文件
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk") 

;; 由菜单修改配置的东西将会保存在custom-file里
(setq custom-file "~/.emacs.d/mydot/xgf-custom.el") 

;; 设置gnus的启动文件
;;(setq gnus-init-file "~/.emacs.d/mydot/xgf-gnus.el") 

;; 把以下缺省禁用的功能都打开
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

;; ****************************************************************************
;; ---------------------------- PART FILE SET BEGIN ---------------------------

;; ------------------------------- basic config -------------------------------
(load "xgf-basic-config")
;; ----------------------------- language set ---------------------------------
(load "xgf-language")

;; ----------------------------- function -------------------------------------
;; 一些函数实现的小功能
(load "xgf-function")

;; --------------------------------- CEDET ------------------------------------
(load "xgf-cedet")

;; ---------------------------------- ECB -------------------------------------
;;(load "xgf-ecb")

;; ----------------------------- desktop set ----------------------------------
;; desktop是Emacs自带的，使用M-x desktop-save后，再次启动Emacs时会打开上次离开时的所有
;; buffer。使用M-x desktop-clear可以删除记住的内容。
(load "desktop") 
(desktop-load-default)
(desktop-read)

;; ----------------------------- session set ----------------------------------
(load "xgf-session")
(add-hook 'after-init-hook 'session-initialize)

;; -----------------------------ibuffer set -----------------------------------
;; ibuffer能把普通的buffer menu换成ibuffer，它的界面和dired相似，通过C-x C-b打开。
(load "xgf-ibuffer")
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; -------------------------- browse kill ring set ----------------------------
;; browse-kill-ring能很方便的在kill-ring里寻找需要的东西，这里把它绑定到C-c k组合键上。
;; 具体的操作请在这个buffer中使用C-h m或者?来查看。
(load "xgf-browse-kill-ring")
(global-set-key [(control c)(k)] 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; -------------------------------tabbar set ----------------------------------
;; 在窗口的顶端设置并打开一个缓冲区列表条，绑定到一些按键上方便切换。
(load "xgf-tabbar")
(tabbar-mode)
(global-set-key [(control up)] 'tabbar-backward-group)
(global-set-key [(control down)] 'tabbar-forward-group)
(global-set-key [(control rigth)] 'tabbar-backward)
(global-set-key [(control left)] 'tabbar-forward)

;; ------------------------------ speedbar set --------------------------------
;; speedbar是Emacs自带的，可以显示文件里的标题、函数、变量等等。通过M-x speedbar打开它。

;; ------------------------------ table set -----------------------------------
;; 可以“所见即所得”地编辑一个文本模式的表格。
;;(autoload 'xgf-table-insert 
;;               "xgf-table" "WYGIWYS table editor")

;; ------------------------------ rect-mark set -------------------------------
;; 调整Emacs自带的“矩形区域操作”，使之更加直观。
;;(load "xgf-rect-mark")

;; ------------------------------ setnu set -----------------------------------
;; 显示文本的行号，不过，它好像不能工作，还缺少setnu-plus.el文件？
;;(load "xgf-setnu")

;; ----------------------------- color theme ----------------------------------
;; 配色方案。通过M-x color-theme-select打开一个配色方案选择窗口，在配色方案上按l（小写的L）
;; 就可以改变当前frame的配色，按i就可以改变所有frame的配色。
;; 如果想选定一个配色方案后就一直使用它，可以按p把当前的配色方案的lisp打印出来，然后加到.emacs
;; 文件；此时，就不需要使用(require 'color-theme)了。
(load "xgf-color-theme")
(require 'color-theme)
;; use xterm
;;(color-theme-arjen)
;;(color-theme-billw)
;;(color-theme-tty-dark)
;;(color-theme-euphoria)
;;(color-theme-snow)
(color-theme-scintilla) ;; OK
;;(color-theme-midnight) ;; OK-1
;;(color-theme-katester) ;; OK-0
;;(color-theme-high-contrast)
;;(color-theme-gray1)
;;(color-theme-dark-laptop)

;; use X Window 
;;(color-theme-gnome2)

;;(load "xgf-color")

;; ---------------------------- thumbs set ------------------------------------
;; thumbs能把Emacs变成一个图片济览器。
;(load "xgf-thumbs")

;; ------------------------------- wiki set -----------------------------------
;; wiki 
;;(load "xgf-wiki")

;; --------------------------------- ido set ----------------------------------
;; 
(load "xgf-ido")


;; --------------------------------- htmlize ----------------------------------
;; 把语法加亮的文件输出成彩色 HTML 文件。
;;(load "xgf-htmlize")

;; ------------------------------- END ----------------------------------------

;(load "xgf-calendar")
;(load "xgf-folding")
;(load "xgf-ido")
;(load "xgf-dictionary")
;(load "mydot/xgf-mew")
;(load "xgf-w3m")
;(load "xgf-erc.el")
;(load "xgf-dired")
;(load "xgf-mode")
;(load "xgf-key-bindings") 

