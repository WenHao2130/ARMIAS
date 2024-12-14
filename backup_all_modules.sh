#!/bin/bash

TARGET_DIR="/data/adb/modules/"
pwddir="$(pwd)"
OUTPUT_DIR="$pwddir/files/modules/"
temp_dirs=("/tmp" "/var/tmp" "/Temp" "/Users/*/Library/Caches" "/storage/emulated/0/Android/data/bin.mt.plus/temp")
for dir in "${temp_dirs[@]}"; do
    if [[ $current_dir == $dir* ]]; then
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本，并且使用root权限执行脚本"
        exit 0
    fi
done
cp "$pwddir/prebuilts/7zzs" "/data/adb/"
chmod 777 "/data/adb/7zzs"
for DIR in "$TARGET_DIR"*/; do

    if [ ! -d "$DIR" ]; then
        continue
    fi

    DIR_NAME=$(basename "$DIR")

    echo "Processing directory: $DIR_NAME"

    if [ ! -f "$pwddir/META-INF/com/google/android/update-binary" ]; then
        echo "缺失META-INF/com/google/android/update-binary文件"
        exit 0
    fi

    if [ ! -f "$pwddir/META-INF/com/google/android/updater-script" ]; then
        echo "缺失META-INF/com/google/android/updater-script文件"
        exit 0
    fi
    mkdir -p "$DIR/META-INF/com/google/android/"
    cp "$pwddir/META-INF/com/google/android/update-binary" "$DIR/META-INF/com/google/android/"
    cp "$pwddir/META-INF/com/google/android/updater-script" "$DIR/META-INF/com/google/android/"
    OUTPUT_FILE="$OUTPUT_DIR/${DIR_NAME}.zip"
    /data/adb/7zzs a -r -mx9 "$OUTPUT_FILE" "$DIR"/*
    rm -rf "$DIR/META-INF/"
    if [ $? -eq 0 ]; then
        echo "Successfully created archive: $OUTPUT_FILE"
    else
        echo "Failed to create archive for directory: $DIR_NAME"
    fi
done
rm -f "/data/adb/7zzs"
echo "All directories have been processed."
