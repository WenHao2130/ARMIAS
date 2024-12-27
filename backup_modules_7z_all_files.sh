#!/system/bin/sh

current_dir=$(pwd)
zip7z="/data/local/tmp/7zzs"
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
cp "$current_dir/prebuilts/7zzs" "/data/local/tmp/"
chmod 777 "$zip7z"
$zip7z a -r -mx=9 "$current_dir"/output.7z "$current_dir"/files/*
if [ $? -eq 0 ]; then
    echo "Successfully created archive: $current_dir/output.7z"
else
    echo "Failed to create archive for directory: output.7z"
fi
rm -rf "$current_dir"/files/*
$zip7z a -r "$current_dir"/ARMIAS.zip "$current_dir"/*
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
rm -f "$current_dir"/backup_all_modules.sh
rm -f "$current_dir"/module.prop
rm -f "$zip7z"
(
    sleep 2
    rm -f "$0"
) &
