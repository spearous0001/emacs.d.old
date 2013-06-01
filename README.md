我的Emacs配置
======

    本配置已经分别在 Windows7 和 Ubuntu 系统下对 Emacs23 和 Emacs24 两个版本进行测试，结果测试均通过。
    本配置的原则：
       （1）不依赖操作系统平台环境；即对Unix及类Unix系统和Windows系统均支持；
       （2）不依赖第三方程序；即只要安装本配置就可100％地完全使用，而不会缺失其它功能，除非有特殊说明。
       （3）安装便捷；即可以使用本配置提供的安装文件来快速安装，也可以手工拷贝直接安装，不需要其它额外的工作。
    
<b>Install——安装<b/>

    首先将本配置包放到任何一个目录下，可以命名为任何一个合法的目录名（不建议命名为“.emacs.d”————以免在某种条件下引起名字冲突）；
    然后在命令行下切换到该配置包的顶层目录中，并执行以下命令：
    本安装支持两种方式：全功能配置和简单配置。
    （1）在Linux及Unix-like平台下：
         1> 安装全功能配置：
            $ sh install-awesome-emacs-on-posix.sh
         2> 安装简单配置：
            $ sh install-simple-emacs-on-posix.sh
         注：如果给以上两个文件添加了可执行权限，可以直接执行，如：
             install-awesome-emacs-on-posix.sh    或    install-simple-emacs-on-posix.sh
    （2）在Windows平台下：
         在Windows下，默认的安装文件仅支持Windows7系统，不支持Windows7以下的版本，比如：Windows XP。否则，您需要自己手工拷贝。
         1> 安装全功能配置：
            .\install-awesome-emacs-on-windows.bat    或    install-awesome-emacs-on-windows.bat
         2> 安装简单配置：
            .\install-simple-emacs-on-windows.bat    或    install-simple-emacs-on-windows.bat
         注：在Windows系统中，也可以直接用鼠标双击这两个BAT批处理文件来完成安装。
            

<b>Directory Structure——目录结构</b>

    .emacs.d/
         backup/                               # 第三方插件备份目录，即目前没有被使用但以后将被使用的插件。
         configs/                              # 配置文件目录，其中包括内置插件和第三方插件的配置文件。
             emacs-basic-config.el             # 基本、简单的配置文件。
         lisps/                                # 第三方插件目录，如果其配置文件较大，将单独成一个文件放置
                                               # 在configs目录，否则将直接放在emacs.config.el文件中。
         emacs-config.el                       # 全功能配置文件，其将引用configs目录下所有的配置文件。
         install-awesome-emacs-on-posix.sh     # POSIX兼容平台下全功能配置安装文件
         install-awesome-emacs-on-windows.bat  # Windows平台下全功能配置安装文件
         install-simple-emacs-on-posix.sh      # POSIX兼容平台下简单配置安装文件
         install-simple-emacs-on-windows.bat   # Windows平台下简配置安装文件
         README.md                             # 说明文件


<b>Questions——问题</b>

    （1）如何查找 Windows 7 系统下用户主目录？
     在Windows7系统下，对Emacs而言，其主目录和VIM等软件对其主目录的看待不一样；对Emacs而言，Windows7用户的主目录较复杂一些。
     其定位方式也行简单：只需要打开Emacs（可以使用任何方式，只要能打开Emacs就行），在Emacs中按组合键“C-x X-f ~”即可，该组合
     键会用Dire模式打开当前用户的主目录，并在Dire缓冲区的第一行显示其主目录的具体位置。
     
     
<b>Other Resources——其他资源</b>

    （1）Emacs Lisp List————Emacs第三方插件收集列表
     http://www.damtp.cam.ac.uk/user/sje30/emacs/ell.html
     
