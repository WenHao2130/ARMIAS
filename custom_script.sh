#欢迎编辑自定义脚本！
#此脚本继承了默认脚本和设置脚本的变量和函数，可以直接调用

#可以自定义变量运行以下函数
#重置获取zip文件索引函数reset_index
#初始化zip文件路径函数initialize_zip_files "路径"
#获取下一个zip文件路径的函数get_next_zip_file
#依次安装单个模块install_zip_files
#循环不必多说，请自行添加
#运行修补补丁patches_install

#安装单个模块例
#zip_file是模块zip文件路径
#zip_file="/path/to/zip_file"
#Installer
#因为代码遗留问题所以你不能直接调用Installer函数

###################################
#补丁模块例
#模块补丁存储的目录
PATCHMOD="patches/modules"
#请创建~/patches/modules/文件夹

#补丁模块的路径一般是/data/adb/modules_update/

#parent_path=$(dirname "$(dirname "$MODPATH")")
#cp -r "$PATCHDATA"/* /"$parent_path"

#如果想补丁模块，请删除上面两行的#号

#补丁规则：将~/patches/modules/目录下的文件复制到data/adb/modules_update/下
#所以请在~/patches/modules/目录下创建与安装模块id相同的文件夹，并将需要补丁的文件放入该文件夹中

#请勿在此脚本使用exit和abort函数