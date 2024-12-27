#!/system/bin/sh

# Custom Script
# -----------------
# This script extends the functionality of the default and setup scripts, allowing direct use of their variables and functions.

# When calling functions without specifying $MODPATH, it will be automatically prefixed. Thus, there is no need to manually add it.
# $MODPATH can be replaced with any path, but please ensure the correctness of the path.

# Overview of Custom Features
# --------------
# 1. Aesthetic Printing: Use Aurora_ui_print "content to be printed" for aesthetic content display.
# 2. Module Installation: The initialize_install "$MODPATH/folder path" function allows automatic installation of all modules in the target directory.
# 3. Patch Installation: The patches_install function iterates through and installs all patches.

# Example: Installing a Single Module
# -----------------
# Installer "$MODPATH/module_path.zip" # to install a specified module.
# For specific root solutions, use Installer "$MODPATH/module_path.zip" "KSU or APATCH or magisk" to automatically execute installation when the target environment is detected; otherwise, installation will not be performed.

# Example: Compatibility Mode Installation
# ----------------
# To install a module in compatibility mode, use Installer_Compatibility_mode "$MODPATH/module_path.zip".

# Example: Extract a single file
# ----------------
# un7z "Filename to be extracted" "Destination folder" # to extract the specified file.

# Example: Volume Key Selection for Module Installation
# ---------------------
# Use key_installer "$MODPATH/upper_key_module_path.zip" "$MODPATH/lower_key_module_path.zip" "Upper key module name to be printed" "Lower key module name to be printed" # to select the module to install via volume keys.
# If the module name is not provided, relevant prompts will not be displayed during installation.

# Example: Use volume keys to select whether to install a module
# -----------------
# key_installer_once "$MODPATH/module_path.zip" "Module name to be printed" # Use volume keys to select whether to install the module.
# Example: Getting the Latest Release File Link from a Github Repository
# github_get_url "repository_owner/repository_name" "filename_to_be_included_in_release"
# The output link address is stored in the $DESIRED_DOWNLOAD_URL variable.

# Example: Downloading a Single File
# download_file "file_link"

# Example: Detecting Volume Key Selection
# ------------------
# After calling key_select, you can get the user's selection result through volume keys via the $key_pressed variable.

# Arbitrary Patch
# patch_default "$MODPATH" "original_path" "patch_path"
# Of course, you can replace $MODPATH with any path to call paths outside the module.

# Example: Patching an Already Installed Module
# -----------------
# To apply patches to already installed modules, use the following command:
# cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules/"

# Example: Move multiple files to /data/adb/
# -----------------
# mv_adb "directory path"

# Example: Adding to Magisk's Denylist
# -----------------
# magisk_denylist_add "package_name" # Only supported by Magisk

# Example: Flash the boot partition
# -----------------
# aurora_flash_boot "file path"

# Notes
# ------
# Please avoid using the exit and abort functions in this script to prevent unexpected interruption of script execution.