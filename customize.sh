#!/bin/bash
main() {
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
    version_check
    initialize_install "$MODPATH/$ZIPLIST"
    download_and_install
    patches_install
    CustomShell
}
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
    if [[ -n $KSU_VER_CODE ]] && [[ $KSU_VER_CODE -lt $ksu_min_version || $KSU_KERNEL_VER_CODE -lt $ksu_min_kernel_version ]]; then
        Aurora_abort "KernelSU: $ERROR_UNSUPPORTED_VERSION $KSU_VER_CODE ($ERROR_VERSION_NUMBER >= $ksu_min_version or kernelVersionCode >= $ksu_min_kernel_version)" 1
    elif [[ -z "$APATCH" && -z "$KSU" && -n "$MAGISK_VER_CODE" ]] && ((MAGISK_VER_CODE < magisk_min_version)); then
        Aurora_abort "Magisk: $ERROR_UNSUPPORTED_VERSION $MAGISK_VER_CODE ($ERROR_VERSION_NUMBER >= $magisk_min_version)" 1
    elif [[ -n $APATCH_VER_CODE && $APATCH_VER_CODE -lt $apatch_min_version ]]; then
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
    if [[ "$fix_ksu_install" == "true" ]] && [[ "$KSU" = true ]] && [[ -z "$KSU_step_skip" ]]; then
        temp_dir="$MODPATH/TEMP_KSU"
        mkdir -p "$temp_dir"
        unzip -d "$temp_dir" "$1" >/dev/null 2>&1
        KSU_Installer_TEMP_ID=$(awk -F= '/^id=/ {print $2}' "$temp_dir/module.prop")
        zip -r "$MODPATH/TEMP_KSU/temp.zip" "$SECURE_DIR/modules_updata/$KSU_Installer_TEMP_ID"/* >/dev/null 2>&1
        KSU_step_skip=true
        Installer "$MODPATH/TEMP_KSU/temp.zip" KSU
        rm -rf "$temp_dir"
        KSU_step_skip=""
    fi
}
initialize_install() {
    local dir="$1"
    local all_files=()
    local delayed_files=()

    if [ ! -d "$dir" ]; then
        Aurora_ui_print "$WARN_ZIPPATH_NOT_FOUND $1"
        return 1
    fi
    while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            all_files+=("$file")
        fi
    done < <(find "$dir" -maxdepth 1 -type f ! -name "$delayed_pattern" -print0 | sort -z)

    while IFS= read -r -d '' delayed_file; do
        if [ -f "$delayed_file" ]; then
            delayed_files+=("$delayed_file")
        fi
    done < <(find "$dir" -maxdepth 1 -type f -name "$delayed_pattern" -print0 | sort -z)

    for file in "${all_files[@]}"; do
        Installer "$file"
    done

    for file in "${delayed_files[@]}"; do
        Installer "$file"
    done

    if [ ${#all_files[@]} -eq 0 ] && [ ${#delayed_files[@]} -eq 0 ]; then
        Aurora_ui_print "$WARN_NO_MORE_FILES_TO_INSTALL"
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
mv_adb() {
    su -c mv "$MODPATH/$1" "/data/adb/"
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
check_network() {
    ping -c 1 www.baidu.com >/dev/null 2>&1
    local baidu_status=$?
    ping -c 1 github.com >/dev/null 2>&1
    local github_status=$?
    ping -c 1 google.com >/dev/null 2>&1
    local google_status=$?

    if [ $baidu_status -eq 0 ]; then
        Aurora_ui_print "$INTERNET_CONNET (Baidu.com)"
        return 0
    elif [ $google_status -eq 0 ]; then
        Aurora_ui_print "$INTERNET_CONNET (Google)"
        return 0
    elif [ $github_status -eq 0 ]; then
        Aurora_ui_print "$INTERNET_CONNET (GitHub)"
        return 0
    else
        return 1
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
github_get_url() {
    local owner_repo="$1"
    local SEARCH_CHAR="$2"
    local API_URL="https://api.github.com/repos/${owner_repo}/releases/latest"
    local TMP_FILE="$MODPATH/TEMP/latest_release_info.json"
    wget -qO- "$API_URL" >"$TMP_FILE"
    DOWNLOAD_URLS=$(grep -oP '"browser_download_url": "\K[^"]+' "$TMP_FILE")
    DESIRED_DOWNLOAD_URL=""
    while IFS= read -r url; do
        if [[ $url == *"$SEARCH_CHAR"* ]]; then
            DESIRED_DOWNLOAD_URL=$url
            break
        fi
    done <<<"$DOWNLOAD_URLS"
    rm -f "$TMP_FILE"
}
download_file() {
    local link=$1
    local filename=$(basename "$link")
    local local_path="$download_destination/$filename"
    local retry_count=0

    while [ $retry_count -lt $max_retries ]; do
        if wget -q "$link" -O "$local_path.tmp"; then
            mv "$local_path.tmp" "$local_path"
            Aurora_ui_print "$DOWNLOAD_SUCCEEDED $local_path"
            return 0
        else
            retry_count=$((retry_count + 1))
            Aurora_ui_print "$DOWNLOAD_FAILED $link. $RETRY_DOWNLOAD $retry_count/$max_retries..."
        fi
    done

    Aurora_ui_print "$DOWNLOAD_FAILED $link"
    Aurora_ui_print "$KEY_VOLUME + $PRESS_VOLUME_RETRY"
    Aurora_ui_print "$KEY_VOLUME - $PRESS_VOLUME_SKIP"
    key_select
    if [ "$key_pressed" == "KEY_VOLUMEUP" ]; then
        download_file "$1"
    fi
    return 1
}
initialize_download() {
    if ! check_network; then
        Aurora_ui_print "$CHECK_NETWORK"
        return
    fi

    for var in $(env | grep '^LINKS_' | cut -d= -f1); do
        link=$(eval echo \$"$var")
        if [ -n "$link" ]; then
            download_file "$link"
        fi
    done
}
download_and_install() {
    if [[ "$Download_before_install" == "false" ]]; then
        return
    elif [[ "$Download_before_install" == "true" ]]; then
        initialize_download
        initialize_install "$download_destination/"
    else
        Aurora_abort "Download_before_install$ERROR_INVALID_LOCAL_VALUE" 4
}
aurora_flash_boot() {
    find_boot_image
    flash_image "$1" "$BOOTIMAGE"
}
magisk_denylist_add() {
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
##########################################################
main
