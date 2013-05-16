我的Emacs配置
======

<b>Install——安装<b/>

    首先将本配置包放到用户的主目录下，并命名为“.emacs.d”（没有两边的双引号）。
    本安装支持两种方式：全功能配置和简单配置。
    （1）在Linux及Unix-like平台下：
         1> 安装全功能配置：
            $ sh install-awesome-emacs-on-posix.sh
         2> 安装简单配置：
            $ sh install-simple-emacs-on-posix.sh
    （2）在Windows平台下：
         在Windows下，默认的安装文件仅支持Windows7系统，不支持Windows7以下的版本，比如：Windows XP。否则，您需要自己手工拷贝。
         1> 安装全功能配置：
            ./install-awesome-emacs-on-windows.bat
         2> 安装简单配置：
            ./install-simple-emacs-on-windows.bat
            

<b>Directory Structure——目录结构</b>

    .emacs.d/
         backup/                               # 第三方插件备份目录，即目前没有被使用但以后将被使用的插件。
         configs/                              # 配置文件目录，其中包括内置插件和第三方插件的配置文件。
             emacs-basic-config.el             # 基本、简单的配置文件。
         lisps/                                # 第三方插件目录，如果其配置文件较大，将单独成一个文件放置
                                               # 在configs目录，否则将直接放在emacs.config.el文件中。
         emacs-config.el                       # 全功能配置文件，其将引用configs目录下自有的配置文件。
         install-awesome-emacs-on-posix.sh     # POSIX兼容平台下全功能配置安装文件
         install-awesome-emacs-on-windows.bat  # Windows平台下全功能配置安装文件
         install-simple-emacs-on-posix.sh      # POSIX兼容平台下简单配置安装文件
         install-simple-emacs-on-windows.bat   # Windows平台下简配置安装文件
         README.md                             # 说明文件


<b>Questions——问题</b>

    （1）如何查找 Windows 7 系统下用户主目录？
     在Windows7系统下，对Emacs而言，其主目录和VIM等软件对其主目录的看待不一样；对Emacs而言，Windows7用户的主目录较复杂一些。其定位方式也行简单：只需要打开Emacs（可以使用任何方式，只要能打开Emacs就行），在Emacs
     中按组合键“C-x X-f ~”即可，该组合键会用Dire模式打开当前用户的主目录，并在Dire缓冲区的第一行显示其主目录的具体位置。
     
     
<b>Other Resources——其他资源</b>

    （1）Emacs Lisp List————Emacs第三方插件收集列表
     http://www.damtp.cam.ac.uk/user/sje30/emacs/ell.html
     
