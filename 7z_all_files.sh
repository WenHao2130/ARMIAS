#!/system/bin/sh

current_dir=$(pwd)
temp_dirs=("/tmp" "/var/tmp" "/Temp" "/Users/*/Library/Caches" "/storage/emulated/0/Android/data/bin.mt.plus/temp")
for dir in "${temp_dirs[@]}"; do
    if [[ $current_dir == $dir* ]]; then
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本，并且使用root权限执行脚本"
        exit 0
    fi
done
cp "$current_dir/prebuilts/7zzs" "/data/local/tmp/"
chmod 777 "/data/local/tmp/7zzs"
/data/local/tmp/7zzs a -r -mx=9 "$current_dir"/output.7z "$current_dir"/files/* 
if [ $? -eq 0 ]; then
    echo "Successfully created archive: $current_dir/output.7z"
else
    echo "Failed to create archive for directory: output.7z"
fi
rm -rf "$current_dir"/files/*
/data/local/tmp/7zzs a -r "$current_dir"/ARMIAS.zip "$current_dir"/*
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
rm -f "/data/local/tmp/7zzs"
(sleep 2; rm -f "$0") &