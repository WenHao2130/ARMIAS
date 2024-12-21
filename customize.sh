#!/system/bin/sh

main() {
    INSTALLER_MODPATH="$MODPATH"
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
    sclect_settings_install_on_main
    patches_install
    CustomShell
    remove_files
    ClearEnv
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
Aurora_test_input() {
    if [[ -z "$3" ]]; then
        Aurora_ui_print "$1 ( $2 ) $WARN_MISSING_PARAMETERS"
    fi
}
#######################################################
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

Installer() {
    Aurora_test_input "Installer" "1" "$1"
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
    local dir="$1"
    local temp_matching_files=$(mktemp)
    local temp_all_files=$(mktemp)
    local temp_zip_files=$(mktemp)

    if [ ! -d "$dir" ]; then
        Aurora_ui_print "$WARN_ZIPPATH_NOT_FOUND $dir"
        rm -f "$temp_matching_files" "$temp_all_files"
        return
    fi
    for entry in "$dir"/*; do
        if [ -d "$entry" ]; then
            local dirname=$(basename "$entry")
            local zip_file="$dir/$dirname.zip"
            zip -r "$zip_file" "$entry" >/dev/null 2>&1
            rm -rf "$entry"
        fi
    done
    find "$dir" -maxdepth 1 -type f -print0 | sort -z >"$temp_all_files"
    while IFS= read -r -d '' file; do
        for pattern in $delayed_patterns; do
            if [[ "$file" == *"$pattern"* ]]; then
                echo "$file" >>"$temp_matching_files"
                break
            fi
        done
    done <"$temp_all_files"
    zygiskmodule="/data/adb/modules/zygisksu/module.prop"
    if [ ! -f "$zygiskmodule" ]; then
        mkdir -p "/data/adb/modules/zygisksu"
        echo "id=zygisksu" >"$zygiskmodule"
        echo "name=Zygisk Placeholder" >>"$zygiskmodule"
        echo "version=1.0" >>"$zygiskmodule"
        echo "versionCode=462" >>"$zygiskmodule"
        echo "author=null" >>"$zygiskmodule"
        echo "description=[Please DO NOT enable] This module is used by the installer to disguise the Zygisk version number for installation via Shamiko" >>"$zygiskmodule"
        touch "/data/adb/modules/zygisksu/remove"
    fi
    while IFS= read -r -d '' file; do
        grep -qFx "$file" "$temp_matching_files" || Installer "$file"
    done <"$temp_all_files"

    while IFS= read -r -d '' file; do
        if [[ "$file" == *Shamiko* ]] && ([[ "$KSU" = true ]] || [[ "$APATCH" = true ]]); then
            SKIP_INSTALL_SHAMIKO=false
            if [[ "$APATCH" = true ]]; then
                Aurora_ui_print "$APATCH_SHAMIKO_INSTALLATION_SKIPPED"
                key_installer "$file" "ZERO" "Shamiko" "$NOT_DO_INSTALL_SHAMIKO"
                SKIP_INSTALL_SHAMIKO=true
            fi
        fi

        if [ "$SKIP_INSTALL_SHAMIKO" != "true" ]; then
            Installer "$file"
        fi
    done <"$temp_matching_files"

    if [ -z "$(cat "$temp_all_files")" ]; then
        Aurora_ui_print "$WARN_NO_MORE_FILES_TO_INSTALL"
    fi

    rm -f "$temp_matching_files" "$temp_all_files"
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
    Aurora_test_input "key_installer" "1" "$1"
    Aurora_test_input "key_installer" "2" "$2"
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
#Abort Internet Connection
##########
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
github_get_url() {
    Aurora_test_input "github_get_url" "1" "$1"
    Aurora_test_input "github_get_url" "2" "$2"
    local owner_repo="$1"
    local SEARCH_CHAR="$2"
    local API_URL="https://api.github.com/repos/${owner_repo}/releases/latest"
    local wget_response_file=$(mktemp)

    wget -S --output-document="$wget_response_file" "$API_URL"

    local TEMP_FILE=$(mktemp)

    $jq -r '.assets[] | select(.name | test("'"$SEARCH_CHAR"'")) | .browser_download_url' "$wget_response_file" >"$TEMP_FILE"
    if [ $? -ne 0 ]; then
        rm -f "$wget_response_file" "$TEMP_FILE"
        Aurora_abort "jq $COMMAND_FAILED"
    fi

    DESIRED_DOWNLOAD_URL=$(cat "$TEMP_FILE")
    if [ -z "$DESIRED_DOWNLOAD_URL" ]; then
        rm -f "$wget_response_file" "$TEMP_FILE"
        Aurora_ui_print "$NOTFOUND_URL"
        return 1
    fi

    Aurora_ui_print "$DESIRED_DOWNLOAD_URL"
    rm -f "$wget_response_file" "$TEMP_FILE"
    return 0
}
download_file() {
    Aurora_test_input "download_file" "1" "$1"
    local link=$1
    local filename=$(wget --spider -S "$link" 2>&1 | grep -o -E 'filename=.*$' | sed -e 's/filename=//')
    local local_path="$download_destination/$filename"
    local retry_count=0
    local wget_file=$(mktemp)
    mkdir -p "$download_destination"

    wget -S --spider "$link" 2>&1 | grep 'Content-Length:' | awk '{print $2}' >"$wget_file"
    file_size_bytes=$(cat "$wget_file")
    if [[ -z "$file_size_bytes" ]]; then
        Aurora_ui_print "$FAILED_TO_GET_FILE_SIZE $link"
    fi
    local file_size_mb=$(echo "scale=2; $file_size_bytes / 1048576" | bc)
    Aurora_ui_print "$DOWNLOADING $filename $file_size_mb MB"
    while [ $retry_count -lt $max_retries ]; do
        wget --output-document="$local_path.tmp" "$link"
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
##############
sclect_settings_install_on_main() {
    jq="$MODPATH"/prebuilts/jq
    zips="$MODPATH"/prebuilts/7zzs
    set_permissions_755 "$jq"
    set_permissions_755 "$zips"
    if [ -f "$MODPATH"/output.7z ]; then
        un7z "$MODPATH/output.7z" "$MODPATH/files/"
        rm "$MODPATH/output.7z"
    fi
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
        if ! check_network; then
            Aurora_ui_print "$CHECK_NETWORK"
            return
        fi

        for var in $(env | grep '^LINKS_' | cut -d= -f1); do
            link=${!var}
            if [ -n "$link" ]; then
                download_file "$link"
            fi
        done
        initialize_install "$download_destination/"
    else
        Aurora_abort "Download_before_install$ERROR_INVALID_LOCAL_VALUE" 4
    fi
}
#About_the_custom_script
###############
mv_adb() {
    Aurora_test_input "mv_adb" "1" "$1"
    su -c mv "$MODPATH/$1"/* "/data/adb/"
}
un7z() {
    Aurora_test_input "un7z" "1" "$1"
    Aurora_test_input "un7z" "2" "$2"
    $zips x "$1" -o"$2" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        Aurora_ui_print "$UNZIP_FINNSH"
    else
        Aurora_ui_print "$UNZIP_ERROR"
    fi
}
aurora_flash_boot() {
    Aurora_test_input "aurora_flash_boot" "1" "$1"
    get_flags
    find_boot_image
    flash_image "$1" "$BOOTIMAGE"
}
magisk_denylist_add() {
    Aurora_test_input "magisk_denylist_add" "1" "$1"
    if [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
        magisk --denylist add "$1" >/dev/null 2>&1
    fi
}
set_permissions_755() {
    Aurora_test_input "set_permissions_755" "1" "$1"
    set_perm "$1" 0 0 0755
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
###############
ClearEnv() {
    rm -rf "$INSTALLER_MODPATH"
}
##########################################################
main
