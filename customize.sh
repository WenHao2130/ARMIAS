#!/bin/bash
if [ ! -f "$MODPATH/settings.txt" ]; then
    abort "Error: notfound file!!!(settings.txt)"
else
    . "$MODPATH/settings.sh"
fi
if [ ! -f "$MODPATH/languages.txt" ]; then
    abort "Error: notfound file!!!(languages.txt)"
else
    . "$MODPATH/languages.txt"
fi
if [ $print_languages == "en" ]; then
    lang_en
elif [ $print_languages == "zh" ]; then
    lang_zh
elif [ $print_languages == "jp" ]; then
    lang_jp
fi
ui_print "---AuroraNasa Installer---"
#######################################################
Aurora_ui_print() {
    sleep 0.05
    ui_print ""
    ui_print "- $1"
}
version_check() {
    if [[ $KSU_VER_CODE != "" ]] && [[ $KSU_VER_CODE -lt $ksu_min_version || $KSU_KERNEL_VER_CODE -lt $ksu_min_kernel_version ]]; then
        abort "$ERROR_TEXTS : KernelSU: $ERROR_SUPPORTED_TEXTS $KSU_VER_CODE ($ERROR_SUPPORTED_VERSION_TEXTS >= $ksu_min_version or kernelVersionCode >= $ksu_min_kernel_version)"
    elif [[ -z $APATCH && -z $KSU && $MAGISK_VER_CODE != "" && $MAGISK_VER_CODE -lt $magisk_min_version ]]; then
        abort "$ERROR_TEXTS : Magisk: $ERROR_SUPPORTED_TEXTS $MAGISK_VER_CODE ($ERROR_SUPPORTED_VERSION_TEXTS >= $magisk_min_version)"
    elif [[ $APATCH_VER_CODE != "" && $APATCH_VER_CODE -lt $apatch_min_version ]]; then
        abort "$ERROR_TEXTS : APatch: $ERROR_SUPPORTED_TEXTS $APATCH_VER_CODE ($ERROR_SUPPORTED_VERSION_TEXTS >= $apatch_min_version)"
    elif [[ $API -lt $ANDROID_API ]]; then
        abort "$ERROR_TEXTS : Android API: $ERROR_SUPPORTED_TEXTS $API ($ERROR_SUPPORTED_VERSION_TEXTS >= $ANDROID_API)"
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
        abort "$ERROR_TEXTS : $ERROR_Installer_TEXTS"
    fi
}
Installer() {
    if [ "$KSU" = true ]; then
        if [ "$KSU_VER_CODE" -le "$ksu_min_normal_version" ]; then
            Installer_Compatibility=true
            Aurora_ui_print "KernelSU: $WARN_Installer_select_Compatibility_mode_TEXTS"
        fi
    elif [ "$APATCH" = true ]; then
        if [ "$APATCH_VER_CODE" -le "$apatch_min_normal_version" ]; then
            Installer_Compatibility=true
            Aurora_ui_print "APatch: $WARN_Installer_select_Compatibility_mode_TEXTS"
        fi
    fi
    if [[ "$Installer_Compatibility" == "false" ]]; then
        Aurora_Installer "$1"
    elif [[ "$Installer_Compatibility" == "true" ]]; then
        Installer_Compatibility_mode "$1"
    else
        abort "$ERROR_TEXTS : $ERROR_Installer_Compatibility_mode_TEXTS"
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
        Aurora_ui_print "$WARN_Installer_ZIPPATH_TEXTS $ZIPLIST"
    else
        for file in "$MODPATH/$ZIPLIST"/*; do
            if [ -f "$file" ]; then
                Installer "$file"
            else
                Aurora_ui_print "$WARN_Installer_ZIP_FOUND_TEXTS"
            fi
        done
    fi
}
patches_install() {
    if [ -d "$MODPATH/$PATCHDATA" ]; then
        if [ -d "$MODPATH/$PATCHDATA" ] && [ "$(ls -A "$MODPATH"/"$PATCHDATA")" ]; then
            cp -r "$MODPATH/$PATCHDATA"/* data/
        else
            Aurora_ui_print "$WARN_Installer_PATCH_FOUND_TEXTS $PATCHDATA"
        fi
    else
        Aurora_ui_print "$PATCHDATA $WARN_Installer_PATCHPATH_TEXTS"
    fi
    if [ -d "$MODPATH/$PATCHSDCARD" ]; then
        if [ -d "$MODPATH/$PATCHSDCARD" ] && [ "$(ls -A "$MODPATH"/"$PATCHSDCARD")" ]; then
            cp -r "$MODPATH/$PATCHSDCARD"/* "$SDCARD"/
        else
            Aurora_ui_print "$WARN_Installer_PATCH_FOUND_TEXTS $PATCHSDCARD"
        fi
    else
        Aurora_ui_print "$PATCHSDCARD $WARN_Installer_PATCHPATH_TEXTS"
    fi
    if [ -d "$MODPATH/$PATCHAPK" ]; then
        apk_found=0
        for apk_file in "$MODPATH"/"$PATCHAPK"/*.apk; do
            if [ -f "$apk_file" ]; then
                if pm install "$apk_file"; then
                    apk_found=1
                else
                    Aurora_ui_print "$WARN_Installer_APK_TEXTS $apk_file"
                fi
            fi
        done
        if [ $apk_found -eq 0 ]; then
            Aurora_ui_print "$WARN_Installer_APK_FOUND_TEXTS $PATCHAPK"
        fi
    else
        Aurora_ui_print "$PATCHAPK $WARN_Installer_PATCHPATH_TEXTS"
    fi
}
key_select() {
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
key_installer() {
    if [ "$3" != "" ] && [ "$4" != "" ]; then
        Aurora_ui_print "$KEY_VOLUME_TEXTS + $KEY_VOLUME_Installer_TEXTS $3"
        Aurora_ui_print "$KEY_VOLUME_TEXTS - $KEY_VOLUME_Installer_TEXTS $4"
    fi
    key_select
    if [ "$key_pressed" == "KEY_VOLUMEUP" ]; then
        Installer "$1"
    else
        Installer "$2"
    fi
}
CustomShell() {
    if [[ "$CustomScript" == "false" ]]; then
        Aurora_ui_print "$Installer_CustomScript_false_TEXTS"
    elif [[ "$CustomScript" == "true" ]]; then
        Aurora_ui_print "$Installer_CustomScript_true_TEXTS"
        source "$MODPATH/$CustomScriptPath"
    else
        abort "$ERROR_TEXTS : $ERROR_Installer_CustomScript_TEXTS"
    fi
}
version_check
initialize_install
patches_install
CustomShell
