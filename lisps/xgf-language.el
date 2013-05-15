
;;整体环境设置
;;(set-language-environment 'Chinese-GB)
(set-language-environment 'utf-8)

;; 键盘输入的编码方式
;;(set-keyboard-coding-system 'gb2312)
(set-keyboard-coding-system 'utf-8)

;;终端下emacs的中文设置？
(set-terminal-coding-system 'utf-8)

;;文件保存时的编码设置
;;(set-buffer-file-coding-system 'gb2312)
(set-buffer-file-coding-system 'utf-8)

;; 新建文件时的编码方式
;;(setq default-buffer-file-coding-system 'gb2312)
(setq default-buffer-file-coding-system 'utf-8)

;; 读取或写入文件名的编码方式
(setq file-name-coding-system 'utf-8)

;;emacs和其他程序互相复制／粘贴的设置
;;(set-selection-coding-system 'gb2312)
;;(set-clipboard-coding-system 'gb2312)
(set-selection-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)


(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(setq-default pathname-coding-system 'utf-8)

;;字体解码优先顺序，从王垠那拷过来的
;;(setq font-encoding-alist
;;(append '(("MuleTibetan-0" (tibetan . 0))
;;("GB2312" (chinese-gb2312 . 0))
;;("JISX0208" (japanese-jisx0208 . 0))
;;("JISX0212" (japanese-jisx0212 . 0))
;;("VISCII" (vietnamese-viscii-lower . 0))
;;("KSC5601" (korean-ksc5601 . 0))
;;("MuleArabic-0" (arabic-digit . 0))
;;("MuleArabic-1" (arabic-1-column . 0))
;;("MuleArabic-2" (arabic-2-column . 0))) font-encoding-alist)) 
