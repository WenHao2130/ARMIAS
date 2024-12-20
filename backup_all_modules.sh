#!/system/bin/sh

TARGET_DIR="/data/adb/modules/"
pwddir="$(pwd)"
OUTPUT_DIR="$pwddir/files/modules/"
temp_dirs=("/tmp" "/temp" "/Temp" "/TEMP" "/TMP" "/Android/data")
for dir in "${temp_dirs[@]}"; do
    if [[ $current_dir == *"$dir"* ]]; then
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        exit 0
    fi
done
if [ "$(whoami)" != "root" ]; then
   echo "此脚本必须以root权限运行。请使用root用户身份运行此脚本。" >&2
   exit 1
fi
for DIR in "$TARGET_DIR"*/; do

    if [ ! -d "$DIR" ]; then
        continue
    fi

    DIR_NAME=$(basename "$DIR")

    echo "Processing directory: $DIR_NAME"

    OUTPUT_FILE="$OUTPUT_DIR/${DIR_NAME}"
    cp -r "$DIR" "$OUTPUT_DIR"
done
echo "All files have been copied to $OUTPUT_DIR"
