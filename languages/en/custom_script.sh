# Custom Script
# -----------------
# This script extends the functionality of the default and setup scripts, allowing direct use of their variables and functions.

# Overview of Custom Features
# --------------
# 1. Aesthetic Printing: Use Aurora_ui_print "content to print" for visually appealing content display.
# 2. Module Installation: The initialize_install function automates the installation of all modules in the $ZIPLIST directory.
# 3. Patch Installation: The patches_install function iterates through and installs all patches.

# Example: Installing a Single Module
# -----------------
# Use Installer "module_path.zip" to install a specific module.

# Example: Compatibility Mode Installation
# ----------------
# To install a module in compatibility mode, use Installer_Compatibility_mode "module_path.zip".

# Example: Volume Key Selection for Module Installation
# ---------------------
# Use key_installer "up_key_module_path.zip" "down_key_module_path.zip" "up_key_module_name" "down_key_module_name" to select and install modules using volume keys.
# If module names are not provided, relevant prompts will not be displayed during installation.

# Example: Detecting Volume Key Selection
# ------------------
# After calling the key_select function, the user's selection made through the volume keys can be accessed via the $key_pressed variable.

# Dedicated Installation Functions
# ------------
# For specific components, the following functions can be used for installation:
# - magisk_installer "module_path.zip"
# - apd_installer "module_path.zip"
# - ksu_installer "module_path.zip"
# These functions automatically execute installation when the target environment is detected.

# Example: Patching Installed Modules
# -----------------
# To apply patches to already installed modules, use the following command:
# cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules/"

# Important Notes
# ------
# Please avoid using the exit and abort functions in this script to prevent accidental interruption of script execution.