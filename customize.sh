#!/bin/bash
main() {
    if [ ! -f "$MODPATH/settings/settings.sh" ]; then
        abort "Notfound File!!!(settings.sh)"
    else
        . "$MODPATH/settings/settings.sh"
    fi
    if [ ! -f "$MODPATH/$langpath" ]; then
        abort "Notfound File!!!($langpath)"
    else
        . "$MODPATH/$langpath"
        eval "lang_$print_languages"
    fi
    version_check
    curl="$MODPATH"/curl
    jq="$MODPATH"/jq
    zips="$MODPATH"/7zzs
    set_permissions_755 "$curl"
    set_permissions_755 "$jq"
    if_un7z_zip
    sclect_settings_install_on_main
    patches_install
    CustomShell
    remove_files
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
        if [[ "$Installer_Log" == "false" ]]; then
            install_module >/dev/null 2>&1
        elif [[ "$Installer_Log" == "true" ]]; then
            install_module
        fi
    done
    MODPATH=$MODPATHBACKUP
}
Aurora_Installer() {
    if [[ "$Installer_Log" == "false" ]]; then
        Aurora_ui_print "$INSTALLER_LOG_DISABLED"
        if [ "$KSU" = true ]; then
            ksud module install "$1" >/dev/null 2>&1
        elif [ "$APATCH" = true ]; then
            apd module install "$1" >/dev/null 2>&1
        elif [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
            magisk --install-module "$1" >/dev/null 2>&1
        else
            Aurora_abort "$ERROR_UPGRADE_ROOT_SCHEME" 3
        fi
    elif [[ "$Installer_Log" == "true" ]]; then
        if [ "$KSU" = true ]; then
            ksud module install "$1"
        elif [ "$APATCH" = true ]; then
            apd module install "$1"
        elif [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
            magisk --install-module "$1"
        else
            Aurora_abort "$ERROR_UPGRADE_ROOT_SCHEME" 3
        fi
    fi
}
Installer() {
    if [[ -z "$1" ]]; then
        Aurora_ui_print "Installer(1)$WARN_MISSING_PARAMETERS"
        return
    fi
    if [[ "$Installer_Log" != "false" ]] && [[ "$Installer_Log" != "true" ]]; then
        Aurora_abort "Installer_Log$ERROR_INVALID_LOCAL_VALUE" 4
    fi
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
        zip -r "$MODPATH/TEMP_KSU/temp.zip" "$SECURE_DIR/modules_update/$KSU_Installer_TEMP_ID"/* >/dev/null 2>&1
        KSU_step_skip=true
        Installer "$MODPATH/TEMP_KSU/temp.zip" KSU
        rm -rf "$temp_dir"
        KSU_step_skip=""
    fi
}
initialize_install() {
    shopt -s nocasematch
    local dir="$1"
    local -a matching_files=()
    local -a all_files=()
    if [ ! -d "$dir" ]; then
        Aurora_ui_print "$WARN_ZIPPATH_NOT_FOUND $dir"
        shopt -u nocasematch
        return
    fi

    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            for pattern in "${delayed_patterns[@]}"; do
                if [[ "$file" == *"$pattern"* ]]; then
                    matching_files+=("$file")
                    break
                fi
            done
            all_files+=("$file")
        fi
    done < <(find "$dir" -maxdepth 1 -type f -print0 | sort -z)

    while IFS= read -r -d '' file; do
        if [[ -f "$file" && ! " ${matching_files[*]} " =~ " $file " ]]; then
            Installer "$file"
        fi
    done < <(find "$dir" -maxdepth 1 -type f -print0 | sort -z)

    if [[ ${#matching_files[@]} -gt 0 ]]; then
        for file in "${matching_files[@]}"; do
            if [[ "$file" == "*Shamiko*" ]] && ([[ "$KSU" = true ]] || [[ "$APATCH" = true ]]); then
                for element in "${all_files[@]}"; do
                    if [[ "$element" != "*zygisk*" ]]; then
                        Aurora_ui_print "$WARN_SHAMIKO_ZYGISK_FILES_FOUND"
                        break
                    fi
                done
                if [[ "$APATCH" = true ]]; then
                    Aurora_ui_print "$APATCH_SHAMIKO_INSTALLATION_SKIPPED"
                    key_installer "$file" "ZERO" "Shamiko" "$NOT_DO_INSTALL_SHAMIKO"
                    SKIP_INSTALL_SHAMIKO=true
                fi
            fi
            if [ "$SKIP_INSTALL_SHAMIKO" != "true" ]; then
                Installer "$file"
                SKIP_INSTALL_SHAMIKO=false
            fi
        done
    fi

    if [[ -z "$(find "$dir" -maxdepth 1 -type f)" ]]; then
        Aurora_ui_print "$WARN_NO_MORE_FILES_TO_INSTALL"
    fi
    shopt -u nocasematch
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
    su -c mv "$MODPATH/$1"/* "/data/adb/"
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
set_permissions_755() {
    set_perm "$1" 0 0 0755
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
        Aurora_ui_print "${KEY_VOLUME}+${KEY_VOLUME_INSTALL_MODULE} $3"
        Aurora_ui_print "${KEY_VOLUME}-${KEY_VOLUME_INSTALL_MODULE} $4"
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
    local curl_response_file=$(mktemp)
    $curl --silent --show-error "$API_URL" >"$curl_response_file"
    if [ $? -ne 0 ]; then
        rm -f "$curl_response_file" "$TEMP_FILE"
        Aurora_abort "curl $COMMAND_FAILED"
    fi
    local TEMP_FILE=$(mktemp)
    $jq -r '.assets[] | select(.name | test("'"$SEARCH_CHAR"'")) | .browser_download_url' "$curl_response_file" >"$TEMP_FILE"
    if [ $? -ne 0 ]; then
        rm -f "$curl_response_file" "$TEMP_FILE"
        Aurora_abort "jq $COMMAND_FAILED"
    fi
    DESIRED_DOWNLOAD_URL=$(cat "$TEMP_FILE")
    if [ -z "$DESIRED_DOWNLOAD_URL" ]; then
        rm -f "$curl_response_file" "$TEMP_FILE"
        Aurora_ui_print "$NOTFOUND_URL"
        return 1
    fi
    Aurora_ui_print "$DESIRED_DOWNLOAD_URL"
    rm -f "$curl_response_file" "$TEMP_FILE"
    return 0
}
download_file() {
    local link=$1
    local filename=$(echo "$link" | grep -oP 'filename=\K[^&]+')
    if [[ -z "$filename" || "$filename" == */* ]]; then
        filename=$(echo "$link" | sed -e 's|.*/\([^?#]*\).*$|\1|')
    fi
    local local_path="$download_destination/$filename"
    local retry_count=0
    local curl_file=$(mktemp)
    mkdir -p "$download_destination"
    $curl -sI "$link" | grep 'Content-Length' | awk '{print $2}' >"$curl_file"
    if [ $? -ne 0 ]; then
        rm -f "$curl_file"
        Aurora_abort "curl $COMMAND_FAILED"
    fi
    file_size_bytes=$(cat "$curl_file")
    if [[ -z "$file_size_bytes" ]]; then
        Aurora_ui_print "$FAILED_TO_GET_FILE_SIZE $link"
    fi
    local file_size_mb=$(echo "scale=2; $file_size_bytes / 1048576" | bc)
    Aurora_ui_print "$DOWNLOADING $filename $file_size_mb MB"
    while [ $retry_count -lt $max_retries ]; do
        $curl -sS -o "$local_path.tmp" "$link"
        if [ -s "$local_path.tmp" ]; then
            mv "$local_path.tmp" "$local_path"
            Aurora_ui_print "$DOWNLOAD_SUCCEEDED $local_path"
            return 0
        else
            retry_count=$((retry_count + 1))
            rm -f "$local_path.tmp"
            Aurora_ui_print "$RETRY_DOWNLOAD $retry_count/$max_retries... $DOWNLOAD_FAILED $filename"
        fi
    done

    Aurora_ui_print "$DOWNLOAD_FAILED $link"
    Aurora_ui_print "${KEY_VOLUME}+${PRESS_VOLUME_RETRY}"
    Aurora_ui_print "${KEY_VOLUME}-${PRESS_VOLUME_SKIP}"
    key_select
    if [ "$key_pressed" == "KEY_VOLUMEUP" ]; then
        download_file "$link"
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
sclect_settings_install_on_main() {
    if [[ "$install" == "false" ]]; then
        return
    elif [[ "$install" == "true" ]]; then
        initialize_install "$MODPATH/$ZIPLIST"
    else
        Aurora_abort "install$ERROR_INVALID_LOCAL_VALUE" 4
    fi
    if [[ "$Download_before_install" == "false" ]]; then
        return
    elif [[ "$Download_before_install" == "true" ]]; then
        initialize_download
        initialize_install "$download_destination/"
    else
        Aurora_abort "Download_before_install$ERROR_INVALID_LOCAL_VALUE" 4
    fi
}
un7z() {
    "$zips" x "$1" -o"$2" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        Aurora_ui_print "$UNZIP_FINNSH"
    else
        Aurora_ui_print "$UNZIP_ERROR"
    fi
}
if_un7z_zip() {
    if [ -f "$MODDIR"/output.7z ]; then
        un7z "$MODDIR/output.7z" "$MODPATH/files/"
        rm "$MODDIR/output.7z"
    fi
}
aurora_flash_boot() {
    get_flags
    find_boot_image
    flash_image "$1" "$BOOTIMAGE"
}
magisk_denylist_add() {
    if [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
        magisk --denylist add "$1" >/dev/null 2>&1
    fi
}
remove_files() {
    rm -rf "$MODDIR/files/"
    rm -f "$MODDIR/curl"
    rm -f "$MODDIR/jq"
    rm -f "$MODDIR/7zzs"
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
