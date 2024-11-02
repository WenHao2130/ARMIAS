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
#语言设置
langpath="languages.txt"
print_languages="zh"
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
magisk_min_version="25400"

#ksu最小兼容版本
ksu_min_version="11300"
#ksu最小兼容内核版本
ksu_min_kernel_version="11300"
#ksu最小正常版本
ksu_min_normal_version="99999"

#apatch最小兼容版本
apatch_min_version="10657"
#apatch最小正常版本
apatch_min_normal_version="10800"

#安卓API最小版本
ANDROID_API="30"
