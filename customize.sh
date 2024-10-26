#!/bin/bash
if [ ! -f "$MODPATH/settings.sh" ]; then
    abort "Error: notfound file!!!(settings.sh)"
else
    . "$MODPATH/settings.sh"
fi
ui_print "---AuroraNasa Installer---"
########################
key_install() {
    key_pressed=""
    while true; do
        local output=$(/system/bin/getevent -qlc 1)
        local key_event=$(echo "$output" | awk '{ print $3 }' | grep 'KEY_')
        local key_status=$(echo "$output" | awk '{ print $4 }')
        if [[ "$key_event" == *"KEY_"* && "$key_status" == "DOWN" ]]; then
            key_pressed="$key_event"
            break
        fi
    done
    while true; do
        local output=$(/system/bin/getevent -qlc 1)
        local key_event=$(echo "$output" | awk '{ print $3 }' | grep 'KEY_')
        local key_status=$(echo "$output" | awk '{ print $4 }')
        if [[ "$key_event" == "$key_pressed" && "$key_status" == "UP" ]]; then
            break
        fi
    done
}
version_check() {
    if [[ $KSU_VER_CODE != "" ]] && [[ $KSU_VER_CODE -lt $ksu_min_version || $KSU_KERNEL_VER_CODE -lt $ksu_min_kernel_version ]]; then
        abort "Unsupported KernelSU version$KSU_VER_CODE (versionCode >= $ksu_min_version or kernelVersionCode >= $ksu_min_kernel_version)"
    elif [[ $MAGISK_VER_CODE != "" && $MAGISK_VER_CODE -lt $magisk_min_version ]]; then
        abort "Unsupported Magisk version$MAGISK_VER_CODE (versionCode >= $magisk_min_version)"
    elif [[ $APATCH_VER_CODE != "" && $APATCH_VER_CODE -lt $apatch_min_version ]]; then
        abort "Unsupported Apatch version$APATCH_VER_CODE (versionCode >= $apatch_min_version)"
    elif [[ $API -lt $ANDROID_API ]]; then
        abort "Unsupported Android version$API (apiVersion >= $ANDROID_API)"
    fi
}
Installer_Compatibility_mode() {
    MODPATHBACKUP=$MODPATH
    for ZIPFILE in $1; do
        install_module
    done
    MODPATH=$MODPATHBACKUP
}
Aurora_Installer() {
    if [ "$KSU" = true ]; then
        ksud module install "$1"
    elif [ "$APATCH" = true ]; then
        apd module install "$1"
    elif [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
        magisk --install-module "$1"
    else
        abort "Error: please upgrade the root plan or change the root plan"
    fi
}
Installer() {
    if [[ "$Installer_Compatibility" == "false" ]]; then
        Aurora_Installer "$1"
    elif [[ "$Installer_Compatibility" == "true" ]]; then
        Installer_Compatibility_mode "$1"
    else
        abort "Error: The value of the Installer_Compatibility is invalid and must be true or false."
    fi
}
magisk_installer() {
    if [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
        Installer "$1"
    fi
}
apd_installer() {
    if [ "$APATCH" = true ]; then
        Installer "$1"
    fi
}
ksu_installer() {
    if [ "$KSU" = true ]; then
        Installer "$1"
    fi
}
initialize_install() {
    if [ ! -d "$MODPATH/$ZIPLIST" ]; then
        ui_print "Notfound $ZIPLIST"
    else
        for file in "$MODPATH/$ZIPLIST"/*; do
            if [ -f "$file" ]; then
                Installer "$file"
            else
                ui_print "No more files to install"
            fi
        done
    fi
}
key_installer() {
    key_install
    if [ "$key_pressed" == "KEY_VOLUMEUP" ]; then
        Installer "$1"
    else
        Installer "$2"
    fi
}
patches_install() {
    if [ -d "$MODPATH/$PATCHDATA" ] && [ "$(ls -A "$MODPATH"/"$PATCHDATA")" ]; then
        cp -r "$MODPATH/$PATCHDATA"/* data/
    else
        ui_print "No files found in $PATCHDATA"
    fi
    if [ -d "$MODPATH/$PATCHSDCARD" ] && [ "$(ls -A "$MODPATH"/"$PATCHSDCARD")" ]; then
        cp -r "$MODPATH/$PATCHSDCARD"/* "$SDCARD"/
    else
        ui_print "No files found in $PATCHSDCARD"
    fi

    if [ -d "$MODPATH/$PATCHAPK" ]; then
        apk_found=0
        for apk_file in "$MODPATH"/"$PATCHAPK"/*.apk; do
            if [ -f "$apk_file" ]; then
                if pm install "$apk_file"; then
                    apk_found=1
                else
                    ui_print "Failed to install $apk_file"
                fi
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
version_check
initialize_install
patches_install
CustomShell
info
