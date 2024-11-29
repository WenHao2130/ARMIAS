# Script configuration parameters

# Base path for module storage
# MODPATH

print_languages="zh"                   # Default language for printing
# Path definitions for various directories
ZIPLIST="/modules"                     # Directory for storing zip modules
PATCHDATA="/patches/data"              # Directory for storing patch DATA
PATCHSDCARD="/patches/sdcard"          # Directory for storing sdcard patches
PATCHAPK="/patches/apks"               # Directory for storing installed APKs (non-system apps)
SDCARD="/storage/emulated/0"           # Path to user-space sdcard
PATCHMOD="/patches/modules"            # Directory for storing patch modules
CustomScriptPath="/custom_script.sh"   # Path to custom script
langpath="/languages.txt"              # Path to language settings file
download_destination="/$SDCARD/Download/AuroraNasa_Installer" # Download path
max_retries="3"                      # Maximum number of download retries

# Advanced settings
Download_before_install=false          # Whether to download and install modules from the network before installing
Installer_Compatibility=false          # Whether to enable compatibility mode for installing modules (not recommended unless necessary)
Installer_Log=true                     # Whether to record logs of module installation
CustomScript=false                     # Whether to enable custom scripts
fix_ksu_install=false                  # Attempt to fix potential installation issues with KernelSU (not recommended unless necessary, may slow down performance and cause unknown issues)
delayed_pattern="*Shamiko*"            # Defines the filename pattern for delayed installation

# User-defined variable area (you can add more variables as needed)

# Version requirements for Magisk and related components
magisk_min_version="25400"             # Minimum required version of Magisk
ksu_min_version="11300"                # Minimum compatible version of KernelSU
ksu_min_kernel_version="11300"         # Minimum compatible kernel version of KernelSU
ksu_min_normal_version="99999"         # Minimum version of KernelSU for regular use
apatch_min_version="10657"             # Minimum compatible version of APatch
apatch_min_normal_version="10832"      # Minimum version of APatch for regular use
ANDROID_API="30"                       # Minimum required Android API version

# Download links (you can add more links as needed)
LINKS_1=""
LINKS_2=""