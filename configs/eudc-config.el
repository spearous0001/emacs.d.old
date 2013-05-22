
;(require 'eudc)
;;在需要的时候加载所需的elisp
(autoload 'dictionary-search "dictionary"
  "Ask for a word and search it in all dictionaries" t)
(autoload 'dictionary-match-words "dictionary"
  "Ask for a word and search all matching words in the dictionaries" t)
(autoload 'dictionary-lookup-definition "dictionary"
  "Unconditionally lookup the word at point." t)
(autoload 'dictionary "dictionary"
  "Create a new dictionary buffer" t)
(autoload 'dictionary-mouse-popup-matching-words "dictionary"
  "Display entries matching the word at the cursor" t)
(autoload 'dictionary-popup-matching-words "dictionary"
  "Display entries matching the word at the point" t)
(autoload 'dictionary-tooltip-mode "dictionary"
  "Display tooltips for the current word" t)
(autoload 'global-dictionary-tooltip-mode "dictionary"
  "Enable/disable dictionary-tooltip-mode for all buffers" t)

;;查单词，只要将光标移到单词上，键入组合键"C-c d"即可，Emacs会开辟一个buffer
;;显示单词释义。
(global-set-key [mouse-3] 'dictionary-mouse-popup-matching-words)
(global-set-key [(control c)(d)] 'dictionary-lookup-definition)
(global-set-key [(control c)(s)] 'dictionary-search)
(global-set-key [(control c)(m)] 'dictionary-match-words)

;;设定字典服务器为本地服务器
;;如果你在包月的宽带上，不妨设定为[url]http://www.dict.org[/url]
;;如果你在局域网上，而局域网的某台机器有dictd服务器，你将服务器设定为他的IP
;;即可。
(setq dictionary-server "localhost")

;;在字典提示模式中，使用wordnet字典数据库作为默认字典数据库
;;当然你可以修改，取决于你dictd服务器里的字典数据库
;(setq dictionary-tooltip-dictionary "wn")
;(require 'dictionary)
;; FIXME :使用这个全局tooltip很费内存啊
;(global-dictionary-tooltip-mode t)

;;在dictd中使用中文字典的时候，需要在~/.emacs中加入字典的编码格式。
;; 设定中文词典的解码
(setq dictionary-coding-systems-for-dictionaries
      '(("cdict" . utf-8)
   ("xdict" . utf-8)
   ("stardic" . utf-8)))

(provide 'jerry-dictionary)
