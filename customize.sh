#!/bin/bash
[ ! -f "$MODPATH/settings.sh" ] && abort "未发现配置文件！(settings.sh)"
source "$MODPATH/settings.sh"
ui_print "---AURORA Installer---"
########################
# 全局变量定义
declare -a zip_files_global
declare -i current_index_global=0
########################
version_check() {
    if [[ $KSU_VER_CODE != "" ]] && [[ $KSU_VER_CODE -lt $ksu_min_version || $KSU_KERNEL_VER_CODE -lt $ksu_min_kernel_version ]]; then
        abort "Unsupported KernelSU version$KSU_VER_CODE (versionCode >= $ksu_min_version or kernelVersionCode >= $ksu_min_kernel_version)"
    elif [[ $MAGISK_VER_CODE != "" && $MAGISK_VER_CODE -lt $magisk_min_version ]]; then
        abort "Unsupported Magisk version$MAGISK_VER_CODE (versionCode >= $magisk_min_version)"
    elif [[ $APATCH_VER_CODE != "" && $APATCH_VER_CODE -lt $apatch_min_version ]]; then
        abort "Unsupported Apatch version$APATCH_VER_CODE (versionCode >= $apatch_min_version)"
    elif [[ $API -lt $ANDRIOD_API ]]; then
        abort "Unsupported Android version$API (apiVersion >= $ANDRIOD_API)"
    fi
}
# 初始化函数，查找所有zip文件并将路径存储到全局数组
initialize_zip_files() {
    local directory="$1"
    readarray -t zip_files_global < <(find "$directory" -maxdepth 1 -type f -name "*.zip")
    current_index_global=0
}

reset_index() {
    current_index_global=0
    ui_print "Index reset."
}

# 获取下一个zip文件路径的函数
get_next_zip_file() {
    if [[ $current_index_global -ge ${#zip_files_global[@]} ]]; then
        ui_print "All zip files have been processed."
        return 1
    fi

    zip_file="${zip_files_global[current_index_global]}"

    ((current_index_global++))
}
Installer_Compatibility_mode() {
    MODPATHBACKUP=$MODPATH
    for ZIPFILE in $zip_file; do
        install_module
    done
    MODPATH=$MODPATHBACKUP
}
Aurora_Installer() {
    if [ "$KSU" = true ]; then
        ksud module install "$zip_file"
    elif [ "$APATCH" = true ]; then
        apd module install "$zip_file"
    elif [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
        magisk --install-module "$zip_file"
    else
        abort "Error, please upgrade the root plan or change the root plan"
    fi
}
Installer() {
    if [[ "$Installer_Compatibility" == "false" ]]; then
        Aurora_Installer
    elif [[ "$Installer_Compatibility" == "true" ]]; then
        Installer_Compatibility_mode
    else
        abort "Error: The value of the Installer_Compatibility is invalid and must be true or false."
    fi
}
install_zip_files() {
    local return_code

    while true; do
        get_next_zip_file
        return_code=$?
        if [[ $return_code -eq 1 ]]; then
            ui_print "No more zip files to process. Exiting loop."
            break
        fi
        Installer
    done
}
patches_install() {
    if [ -d "$PATCHDATA" ] && [ "$(ls -A $PATCHDATA)" ]; then
        cp -r "$PATCHDATA"/* /data/

        files=($(find "$PATCHDATA" -type f | sed "s|^$PATCHDATA/||"))
        for file in "${files[@]}"; do
            chmod 777 "data/$file"
        done
    else
        ui_print "No files found in $PATCHDATA"
    fi

    if [ -d "$PATCHSDCARD" ] && [ "$(ls -A $PATCHSDCARD)" ]; then
        cp -r "$PATCHSDCARD"/* "$SDCARD"/
        
        files=($(find "$PATCHSDCARD" -type f | sed "s|^$PATCHSDCARD/||"))
        for file in "${files[@]}"; do
            chmod 777 "$SDCARD/$file"
        done
    else
        ui_print "No files found in $PATCHSDCARD"
    fi

    if [ -d "$PATCHAPK" ]; then
        apk_found=0
        for apk_file in "$PATCHAPK"/*.apk; do
            if [ -f "$apk_file" ]; then
                install "$apk_file"
                apk_found=1
            fi
        done
        if [ $apk_found -eq 0 ]; then
            ui_print "No APK files found in $PATCHAPK"
        fi
    else
        ui_print "$PATCHAPK directory does not exist"
    fi
}
CustomShell() {
    if [[ "$CustomScript" == "false" ]]; then
        ui_print "CustomShell is disabled.Will not execute CustomScript."
    elif [[ "$CustomScript" == "true" ]]; then
        ui_print "CustomShell is enabled.Executing CustomScript."
        source "$MODPATH/$CustomScriptPath"
    else
        abort "Error: The value of the CustomScript is invalid and must be true or false."
    fi
}
###############
delete_temp_files() {
    rm -rf "$MODPATH"
}
version_check
initialize_zip_files "$MODPATH/$ZIPLIST"
install_zip_files
patches_install
CustomShell
