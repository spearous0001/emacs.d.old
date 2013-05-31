
;; ****************************************************************************
;; ----------------------------------------------------------------------------
;; ------------------------------- load-path ----------------------------------
(setq load-path (cons "~/.emacs.d/lisps/" load-path))
(setq load-path (cons "~/.emacs.d/configs/" load-path))
(setq load-path (cons "~/.emacs.d/lisps/apel/" load-path))

;; ----------------------------------------------------------------------------
;; ------------------------------- basic-config -------------------------------
;; Emacs的基本配置
(load "emacs-basic-config")

;; ----------------------------------------------------------------------------
;; --------------------------------- functions --------------------------------
;; 实现一些小功能
(load "functions")


;; ****************************************************************************
;; ================================= Built-ins ================================
;; ----------------------------------------------------------------------------
;; --------------------------------- linum-mode -------------------------------
;; 从Emacs23开始，Emacs内置了linum-mode模式，可以显示行号
(require 'linum)
(global-linum-mode t)
(setq linum-format " %4d \u2502 ")  ;; "\u2502"表示字符"|"

;; ----------------------------------------------------------------------------
;; -------------------------------- ibuffer -----------------------------------
;; ibuffer把普通的buffer menu换成ibuffer，它的界面和dired相似，通过C-x C-b打开。
(load "ibuffer")
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; ----------------------------------------------------------------------------
;; ----------------------------------- ido ------------------------------------
(load "ido-config")

;; ----------------------------------------------------------------------------
;; -------------------------------- thumbs ------------------------------------
;; thumbs能把Emacs变成一个图片济览器。
(load "thumbs")

;; ----------------------------------------------------------------------------
;; --------------------------------- speedbar ---------------------------------
;; speedbar是Emacs自带的，可以显示文件里的标题、函数等。通过M-x speedbar打开。

;; ----------------------------------------------------------------------------
;; --------------------------------- cedet ------------------------------------
(load "cedet-config")

;; ----------------------------------------------------------------------------
;; ---------------------------------- eudc ------------------------------------
;; Emacs内置的字典配置
(load "eudc-config")

;; ----------------------------------------------------------------------------
;; --------------------------------- hl-line ----------------------------------
;; Highlight the current line.
(require 'hl-line)
(global-hl-line-mode 1)

;; ================================ Extensions ================================
;; ----------------------------------------------------------------------------
;; ---------------------------------- mode ------------------------------------
;; 各种模式的设置，包括编程语言主副模式。
(load "mode-config")

;; ----------------------------------------------------------------------------
;; -------------------------------- color-theme -------------------------------
;; color-theme是Emacs的第三方颜色配置方案。
(load "color-theme-config")

;; ----------------------------------------------------------------------------
;; --------------------------------- session ----------------------------------
(load "session")
(add-hook 'after-init-hook 'session-initialize)

;; ----------------------------------------------------------------------------
;; ----------------------------- browse kill ring -----------------------------
;; browse-kill-ring能很方便的在kill-ring里寻找需要的东西，这里把它绑定到C-c k
;; 组合键上。具体的操作请在这个buffer中使用C-h m或者?来查看。
(load "browse-kill-ring")
(global-set-key [(control c)(k)] 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; ----------------------------------------------------------------------------
;; --------------------------------- tabbar -----------------------------------
;; 在窗口的顶端设置并打开一个缓冲区列表条，绑定到一些按键上方便切换。
(when (window-system)
    (load "tabbar")
    (tabbar-mode  t)
    (global-set-key [(control up)] 'tabbar-backward-group)
    (global-set-key [(control down)] 'tabbar-forward-group)
    (global-set-key [(control rigth)] 'tabbar-backward)
    (global-set-key [(control left)] 'tabbar-forward))

;; ----------------------------------------------------------------------------
;; --------------------------------- table ------------------------------------
;; 可以“所见即所得”地编辑一个文本模式的表格。
(autoload 'table-insert
               "table" "WYGIWYS table editor")

;; ----------------------------------------------------------------------------
;; --------------------------------- rect-mark --------------------------------
;; 调整Emacs自带的“矩形区域操作”，使之更加直观。
;; 还需要额外的配置（具体地参见rect-mark.el文件）
(load "rect-mark")

;; ----------------------------------------------------------------------------
;; --------------------------------- htmlize ----------------------------------
;; 把语法加亮的文件输出成彩色 HTML 文件。
;(load "htmlize")

;; ----------------------------------------------------------------------------
;; ---------------------------------- ecb -------------------------------------
;; 其需要Cedet完整版，上述cedet配置对应的Cedet是Emacs内置版本。
;; 待重新安装、配置Cedet。
;(load "ecb-config")

;; ----------------------------------------------------------------------------
;; ------------------------------- debian-el ----------------------------------
;; Debian系列（及其衍生版本）平台下各种文件模式的编辑。
(load "debian-el-config")

;; ----------------------------------------------------------------------------
;; --------------------------------- header2 ----------------------------------
;; Support for creation and update of file headers.
(require 'header2)
(add-hook 'emacs-lisp-mode-hook 'auto-make-header)
;(add-hook 'c-mode-hook 'auto-make-header)
(add-hook 'c-mode-common-hook 'auto-make-header)
(add-hook 'c++-mode-hook 'auto-make-header)
(add-hook 'python-mode-hook 'auto-make-header)
;(add-hook 'python2-mode-hook 'auto-make-header)
;(add-hook 'python3-mode-hook 'auto-make-header)

;; ------------------------------- END ----------------------------------------
;; ****************************************************************************
