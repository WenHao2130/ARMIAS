# Script Configuration Parameters

# Base path for module storage
# MODPATH

# Path definitions for various directories
ZIPLIST="/modules"                     # Directory for storing zip modules
PATCHDATA="/patches/data"              # Directory for storing patch data
PATCHSDCARD="/patches/sdcard"          # Directory for storing sdcard patches
PATCHAPK="/patches/apks"               # Directory for storing APKs to install (non-system apps)
SDCARD="/storage/emulated/0"           # Path to user-space sdcard
PATCHMOD="/patches/modules"            # Directory for storing patch modules
CustomScriptPath="/custom_script.sh"   # Path to the custom script

# Advanced Settings
langpath="languages.txt"               # Path to the language settings file
print_languages="en"                   # Default language for printing
Installer_Compatibility=false          # Whether to enable compatibility mode for installing modules (not recommended unless necessary)
Installer_Log=true                     # Whether to log the installation of modules
CustomScript=false                     # Whether to enable the custom script

# User-defined variable area (you can add more variables as needed)

# Version requirements for Magisk and related components
magisk_min_version="25400"             # Minimum required version of Magisk
ksu_min_version="11300"                # Minimum compatible version of KernelSU required
ksu_min_kernel_version="11300"         # Minimum compatible kernel version of KernelSU required
ksu_min_normal_version="99999"         # Minimum version of KernelSU required for regular use
apatch_min_version="10657"             # Minimum compatible version of APatch required
apatch_min_normal_version="10832"      # Minimum version of APatch required for regular use
ANDROID_API="30"                       # Minimum required Android API version