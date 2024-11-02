# Welcome to edit the custom script!
# This script inherits variables and functions from the default and setup scripts, which can be called directly.

# You can define custom variables and run the following functions
# Aurora_ui_print "Print content"
# This function is more aesthetically pleasing compared to ui_print
# Iterate through and install modules under $ZIPLIST with initialize_install
# No need to explain the loop, please add it yourself
# Run patches_install to apply patches
###################################
# Example of installing a single module
# Installer "path/to/module.zip"

# Call compatibility mode
# Installer_Compatibility_mode "path/to/module.zip"
###################################
# Example of installing modules with volume keys: $1 is the module installed with the volume up key, $2 is the module installed with the volume down key, $3 is the name of the module for the volume up key, $4 is the name of the module for the volume down key - module names are optional
# If you don't fill in the module name, it will not output the prompt "Install xxx module with volume up key" and "Install xxx module with volume down key"
# key_installer "path/to/module.zip" "path/to/module.zip" "Module Name" "Module Name"

# You can also call the volume key detection function
# key_select
# The detection result is stored in the $key_pressed variable
###################################
# magisk_installer "path/to/module.zip"
# apd_installer "path/to/module.zip"
# ksu_installer "path/to/module.zip"
# Detect if in the target environment, if so, run the installation, otherwise do not run
###################################
# Example of patching a module

# Directory where module patches are stored
PATCHMOD="patches/modules"
# Please create the ~/patches/modules/ folder

# cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules_update/"

# If you want to patch a module, please remove the # symbol from the line above
# The path for patching modules is generally /data/adb/modules_update/
# Patching rule: Copy files from the ~/patches/modules/ directory to data/adb/modules_update/
# So, please create a folder with the same ID as the installed module under ~/patches/modules/, and put the files that need patching into that folder

# Example of patching an already installed module
# cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules/"

# Please do not use the exit and abort functions in this script
