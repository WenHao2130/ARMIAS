#!/bin/bash

TARGET_DIR="data/adb/modules/"
pwddir="$(pwd)"
OUTPUT_DIR="$pwddir/files/modules/"

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

    if [ ! -f "$pwddir/META-INF/com/google/android/update-script" ]; then
        echo "缺失META-INF/com/google/android/update-script文件"
        exit 0
    fi
    mkdir -p "$DIR/META-INF/com/google/android/"
    cp "$pwddir/META-INF/com/google/android/update-binary" "$DIR/META-INF/com/google/android/"
    cp "$pwddir/META-INF/com/google/android/update-script" "$DIR/META-INF/com/google/android/"
    OUTPUT_FILE="$OUTPUT_DIR/${DIR_NAME}.7z"
    "$current_dir/7zzs" a -mx9 "$OUTPUT_FILE" "$DIR"/*
    rm -rf "$DIR/META-INF/"
    if [ $? -eq 0 ]; then
        echo "Successfully created archive: $OUTPUT_FILE"
    else
        echo "Failed to create archive for directory: $DIR_NAME"
    fi
done

echo "All directories have been processed."
