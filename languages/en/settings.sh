#!/bin/bash
# The path is under $MODPATH
# Directory where zip modules are stored
ZIPLIST="modules"

# The patch module has unknown issues (no issues with Magisk), and has been deprecated. If you need to use it, please edit the custom script yourself.

# Directory where patch DATA is stored
PATCHDATA="patches/data"
# Directory where patch sdcard is stored
PATCHSDCARD="patches/sdcard"
# Directory where installed APKs (non-system apps) are stored
PATCHAPK="patches/apks"
# Userspace path
SDCARD="/storage/emulated/0"

# Advanced settings
# languages settings
langpath="languages.txt"
print_languages="en"
# Install modules in compatibility mode, no need to enable unless necessary
Installer_Compatibility="false"
# Whether to enable custom scripts
CustomScript="false"
# Custom script path
CustomScriptPath="custom_script.sh"
####################################
# You can add custom variables here
####################################

# Minimum version of Magisk
magisk_min_version="25400"

# Minimum compatible version of ksu
ksu_min_version="11300"
# Minimum compatible kernel version of ksu
ksu_min_kernel_version="11300"
# Minimum normal version of ksu
ksu_min_normal_version="99999"

# Minimum compatible version of apatch
apatch_min_version="10657"
# Minimum normal version of apatch
apatch_min_normal_version="10800"

# Minimum Android API version
ANDROID_API="30"