
[简体中文](README.md) | [日本語](README_JP.md) | **English**

# Highly Customizable Automatic Installation Module

#### Basic Operations


- Simply place all modules (zip files) into the `modules` folder.

**Note**: Please ensure that file names do **not contain special characters**.

#### Advanced Features (Optional Reading)


- **One-Click DATA and SDCARD Overwrite**
  - Considering that some modules generate configuration files in the data/ or android folders after installation.
  - This module provides a one-click function to batch copy target files within the module to data/ or sdcard/, facilitating module configuration and usage.
  - Additionally, it supports direct modification of `/data` and `/sdcard`.
  **Note**: This operation will copy all files under the "module's target directory/*". Please ensure the correct folder structure is set and **permissions are properly configured**.
  Example target directories: `patches/sdcard`, `patches/data/`, `patches/apks`


- **Automatic Batch Installation of APKs** `(su)`
  - A straightforward feature that allows you to batch install APKs with ease.


- **Post-Installation Module Patching**
  - This feature is relatively simple and does not require further elaboration.


- **Configuration File: settings.sh**
  - Supports modifying up to 80% of the module's path variables, language settings, minimum Android API, Magisk version, ksu version, apatch version, and custom scripts.
  - **If you encounter installation issues, please try enabling **Compatibility Mode**.**


- **Language File**
  - Default path: `languages.txt`
  - Supports modifying the language file.


- **Advanced Feature: Custom Installation Templates**
  - See comments for details.

#### Compatibility


- Compatible with Magisk, KernelSU, and APatch.

- Supports installing Magisk modules in TWRP.

#### User Guide


- Place modules (zip files) into the `modules` folder.

- Organize other files into corresponding subfolders within the `patches` folder.

#### Important Note


- **Please do not include special characters in file names.**