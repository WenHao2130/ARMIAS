#!/system/bin/sh
TARGET_DIR="/data/adb/modules/"
current_dir=$(pwd)
OUTPUT_DIR="$pwddir/files/modules/"
zstd="/data/local/tmp/zstd"
temp_dirs=("/tmp" "/temp" "/Temp" "/TEMP" "/TMP" "/Android/data")
for dir in "${temp_dirs[@]}"; do
    if [[ $current_dir == *"$dir"* ]]; then
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "The current directory is a temporary directory or its subdirectory. Please extract to another directory before executing the script."
        exit 0
    fi
done
if [ "$(whoami)" != "root" ]; then
   echo "此脚本必须以root权限运行。请使用root用户身份运行此脚本。"
   echo "This script must be run with root privileges. Please run this script as a root user."
   exit 1
fi
echo "脚本正在以root权限运行。"
cp "$current_dir/prebuilts/zstd" "/data/local/tmp/"
chmod 777 "$zstd"
cp -r "$TARGET_DIR"/* "$OUTPUT_DIR"
echo "All files have been copied to $OUTPUT_DIR"
tar -cf "$current_dir"/archive.tar "$current_dir"/files/*
$zstd "$current_dir"/output.tar.zst "$current_dir"/archive.tar
rm "$current_dir"/archive.tar
if [ $? -eq 0 ]; then
    echo "Successfully created archive: $current_dir/output.tar.zst"
else
    echo "Failed to create archive for directory: output.tar.zst"
fi
rm -rf "$current_dir"/files/*
zip -r "$current_dir"/ARMIAS.zip "$current_dir/"
if [ $? -eq 0 ]; then
    echo "Successfully created archive: $current_dir/ARMIAS.zip"
else
    echo "Failed to create archive for directory: ARMIAS.zip"
    exit 0
fi
rm -rf "$current_dir"/prebuilts/
rm -rf "$current_dir"/files/
rm -rf "$current_dir"/META-INF/
rm -rf "$current_dir"/settings/
rm -f "$current_dir"/customize.sh
rm -f "$current_dir"/languages.ini
rm -f "$current_dir"/service.sh
rm -f "$current_dir"/output.7z
rm -f "$current_dir"/backup_all_modules_zip.sh
rm -f "$current_dir"/module.prop
rm -f "$zip7z"
(
    sleep 2
    rm -f "$0"
) &
