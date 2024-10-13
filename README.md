#Auto Install And Setting Modules
一款全自动安装并配置模块，Magisk模块

#使用指南 (10.13)
下文指的路径全是zip文件下的路径
一般用法：
1.批量安装模块
- 将你的zip模块文件放入modules文件夹即可，不需要改名。
2.覆盖文件(data)(sdcard)
- 将文件放入patches/data/或者patches/sdcard/
！！！注意 是直接将文件复制到目标目录，所以请保证文件夹格式正确
3.安装apk，直接将apk文件放入patches/apks即可
4.修补已安装的模块(modules_update)
！请启用自定义脚本，并在自定义脚本中编辑它
进阶用法：
详情见settings.sh和custom_script.sh