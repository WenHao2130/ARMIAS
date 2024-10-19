#!/bin/bash
#路径在$MODPATH下

#zip模块存储的目录
ZIPLIST="modules"

#补丁模块存在未知问题（Magisk无问题），已弃用，如需使用请自行编辑自定义脚本

#补丁DATA存储的目录
PATCHDATA="patches/data"
#补丁sdcard存储的目录
PATCHSDCARD="patches/sdcard"
#安装APK存储的目录（非系统应用）
PATCHAPK="patches/apks"
#用户态路径
SDCARD="/storage/emulated/0"


#高级设置

#兼容模式安装模块，非必要时不需要开启
Installer_Compatibility="false"
#是否启用自定义脚本
CustomScript="false"
#自定义脚本路径
CustomScriptPath="custom_script.sh"
####################################
#可在此添加自定义变量
####################################

#magisk最小版本
magisk_min_version="26000"
#ksu最小版本
ksu_min_version="11847"
#ksu最小内核版本
ksu_min_kernel_version="11847"
#apatch最小版本
apatch_min_version="10657"
#安卓API最小版本
ANDROID_API="30"
