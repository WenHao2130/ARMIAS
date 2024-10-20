#欢迎编辑自定义脚本！
#此脚本继承了默认脚本和设置脚本的变量和函数，可以直接调用

#可以自定义变量运行以下函数
#遍历安装$ZIPLIST下的模块initialize_install
#循环不必多说，请自行添加
#运行遍历修补补丁patches_install
###################################
#安装单个模块例
#Installer "path/to/module.zip"
#调用兼容模式
#Installer_Compatibility_mode "path/to/module.zip"
###################################
#补丁模块例

#模块补丁存储的目录
PATCHMOD="patches/modules"
#请创建~/patches/modules/文件夹

#cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules_update/"

#如果想补丁模块，请删除上面一行的#号
#补丁模块的路径一般是/data/adb/modules_update/
#补丁规则：将~/patches/modules/目录下的文件复制到data/adb/modules_update/下
#所以请在~/patches/modules/目录下创建与安装模块id相同的文件夹，并将需要补丁的文件放入该文件夹中

#补丁已安装模块例
#cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules/"

#请勿在此脚本使用exit和abort函数