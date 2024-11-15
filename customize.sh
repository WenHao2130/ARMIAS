#!/bin/bash
if [ ! -f "$MODPATH/settings.sh" ]; then
    abort "Notfound File!!!(settings.sh)"
else
    . "$MODPATH/settings.sh"
fi
if [ ! -f "$MODPATH/$langpath" ]; then
    abort "Notfound File!!!($langpath)"
else
    . "$MODPATH/$langpath"
    eval "lang_$print_languages"
fi
#######################################################
Aurora_ui_print() {
    sleep 0.05
    ui_print ""
    ui_print "- $1"
}
Aurora_abort() {
    ui_print "$ERROR_TEXT: $1"
    abort "$ERROR_CODE_TEXT: $2"
}
version_check() {
    if [[ -n $KSU_VER_CODE  ]] && [[ $KSU_VER_CODE -lt $ksu_min_version || $KSU_KERNEL_VER_CODE -lt $ksu_min_kernel_version ]]; then
        Aurora_abort "KernelSU: $ERROR_UNSUPPORTED_VERSION $KSU_VER_CODE ($ERROR_VERSION_NUMBER >= $ksu_min_version or kernelVersionCode >= $ksu_min_kernel_version)" 1
    elif [[ -z "$APATCH" && -z "$KSU" && -n "$MAGISK_VER_CODE" ]] && ((MAGISK_VER_CODE < magisk_min_version)); then
        Aurora_abort "Magisk: $ERROR_UNSUPPORTED_VERSION $MAGISK_VER_CODE ($ERROR_VERSION_NUMBER >= $magisk_min_version)" 1
    elif [[ -n $APATCH_VER_CODE  && $APATCH_VER_CODE -lt $apatch_min_version ]]; then
        Aurora_abort "APatch: $ERROR_UNSUPPORTED_VERSION $APATCH_VER_CODE ($ERROR_VERSION_NUMBER >= $apatch_min_version)" 1
    elif [[ $API -lt $ANDROID_API ]]; then
        Aurora_abort "Android API: $ERROR_UNSUPPORTED_VERSION $API ($ERROR_VERSION_NUMBER >= $ANDROID_API)" 2
    fi
}
Installer_Compatibility_mode() {
    MODPATHBACKUP=$MODPATH
    # shellcheck disable=SC2034
    for ZIPFILE in $1; do
        install_module $redirect_output
    done
    MODPATH=$MODPATHBACKUP
}
Aurora_Installer() {
    if [ "$KSU" = true ]; then
        ksud module install "$1" $redirect_output
    elif [ "$APATCH" = true ]; then
        apd module install "$1" $redirect_output
    elif [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
        magisk --install-module "$1" $redirect_output
    else
        Aurora_abort "$ERROR_UPGRADE_ROOT_SCHEME" 3
    fi
}
Installer() {
    if [ "$2" != "" ]; then
        if [[ "$2" = "KSU" ]] && [[ "$KSU" != true ]]; then
            return
        fi
        if [[ "$2" = "APATCH" ]] && [[ "$APATCH" != true ]]; then
            return
        fi
        if [[ "$2" = "MAGISK" ]] && [[ -z "$APATCH" ]] && [[ -z "$KSU" ]] && [[ "$MAGISK_VER_CODE" != "" ]]; then
            return
        fi
    fi
    if [ "$KSU" = true ]; then
        if [ "$KSU_VER_CODE" -le "$ksu_min_normal_version" ]; then
            Installer_Compatibility=true
            Aurora_ui_print "KernelSU: $WARN_FORCED_COMPATIBILITY_MODE"
        fi
    elif [ "$APATCH" = true ]; then
        if [ "$APATCH_VER_CODE" -le "$apatch_min_normal_version" ]; then
            Installer_Compatibility=true
            Aurora_ui_print "APatch: $WARN_FORCED_COMPATIBILITY_MODE"
        fi
    fi
    if [[ "$Installer_Log" == "false" ]]; then
        Aurora_ui_print "$INSTALLER_LOG_DISABLED"
        redirect_output='> /dev/null 2>&1'
    elif [[ "$Installer_Log" == "true" ]]; then
        Aurora_ui_print "$INSTALLER_START_LOG_ENABLED"
    else
        Aurora_abort "Installer_Log$ERROR_INVALID_LOCAL_VALUE" 4
    fi
    if [[ "$Installer_Compatibility" == "false" ]]; then
        Aurora_Installer "$1"
    elif [[ "$Installer_Compatibility" == "true" ]]; then
        Installer_Compatibility_mode "$1"
    else
        Aurora_abort "Installer_Compatibility$ERROR_INVALID_LOCAL_VALUE" 4
    fi
}
initialize_install() {
    if [ ! -d "$MODPATH/$ZIPLIST" ]; then
        Aurora_ui_print "$WARN_ZIPPATH_NOT_FOUND $ZIPLIST"
    else
        for file in "$MODPATH/$ZIPLIST"/*; do
            if [ -f "$file" ]; then
                Installer "$file"
            else
                Aurora_ui_print "$WARN_NO_MORE_FILES_TO_INSTALL"
            fi
        done
    fi
}
patch_default() {
    if [ -d "$1/$2" ]; then
        if [ -d "$1/$2" ] && [ "$(ls -A "$1"/"$2")" ]; then
            cp -r "$1/$2"/* "$3"/
        else
            Aurora_ui_print "$WARN_PATCH_NOT_FOUND_IN $2"
        fi
    else
        Aurora_ui_print "$2 $WARN_PATCHPATH_NOT_FOUND_IN_DIRECTORY"
    fi
}
patches_install() {
    patch_default "$MODPATH" "$PATCHDATA" "/data"
    patch_default "$MODPATH" "$PATCHSDCARD" "$SDCARD"
    patch_default "$MODPATH" "$PATCHMOD" "$SECURE_DIR/modules_update/"
    if [ -d "$MODPATH/$PATCHAPK" ]; then
        apk_found=0
        for apk_file in "$MODPATH"/"$PATCHAPK"/*.apk; do
            if [ -f "$apk_file" ]; then
                if pm install "$apk_file"; then
                    apk_found=1
                else
                    Aurora_ui_print "$WARN_APK_INSTALLATION_FAILED $apk_file"
                fi
            fi
        done
        if [ $apk_found -eq 0 ]; then
            Aurora_ui_print "$WARN_PATCH_NOT_FOUND_IN $PATCHAPK"
        fi
    else
        Aurora_ui_print "$PATCHAPK $WARN_PATCHPATH_NOT_FOUND_IN_DIRECTORY"
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
only_magisk() {
    if [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
        magisk --denylist add "$1" >/dev/null 2>&1
    fi
}
CustomShell() {
    if [[ "$CustomScript" == "false" ]]; then
        Aurora_ui_print "$CUSTOM_SCRIPT_DISABLED"
    elif [[ "$CustomScript" == "true" ]]; then
        Aurora_ui_print "$CUSTOM_SCRIPT_ENABLED"
        source "$MODPATH/$CustomScriptPath"
    else
        Aurora_abort "CustomScript$ERROR_INVALID_LOCAL_VALUE" 4
    fi
}
version_check
initialize_install
patches_install
CustomShell
