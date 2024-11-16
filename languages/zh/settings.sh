# 脚本配置参数

# 模块存储的基础路径
# MODPATH

# 各个目录的路径定义
ZIPLIST="/modules"                     # zip模块存储的目录
PATCHDATA="/patches/data"              # 补丁DATA存储的目录
PATCHSDCARD="/patches/sdcard"          # 补丁sdcard存储的目录
PATCHAPK="/patches/apks"               # 安装APK存储的目录（非系统应用）
SDCARD="/storage/emulated/0"           # 用户态sdcard路径
PATCHMOD="/patches/modules"            # 补丁模块存储的目录
CustomScriptPath="/custom_script.sh"   # 自定义脚本的路径
langpath="/languages.txt"              # 语言设置文件路径


# 高级设置
print_languages="zh"                   # 默认打印的语言
Installer_Compatibility=false          # 是否启用兼容模式安装模块（非必要时不建议开启）
Installer_Log=true                     # 是否记录安装模块的日志
CustomScript=false                     # 是否启用自定义脚本
delayed_patterns=("*Shamiko*" "*Pattern2*" "*Pattern3*")  # 定义需要延迟安装的文件名模式数组

# 用户自定义变量区域（可根据需要添加更多变量）

# Magisk及相关组件的版本要求
magisk_min_version="25400"             # 要求的Magisk最低版本
ksu_min_version="11300"                # 要求的KernelSU最低兼容版本
ksu_min_kernel_version="11300"         # 要求的KernelSU最低兼容内核版本
ksu_min_normal_version="99999"         # 要求的KernelSU常规使用最低版本
apatch_min_version="10657"             # 要求的APatch最低兼容版本
apatch_min_normal_version="10832"      # 要求的APatch常规使用最低版本
ANDROID_API="30"                       # 要求的最低安卓API版本
