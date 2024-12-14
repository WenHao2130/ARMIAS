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
cp "$current_dir/prebuilts/7zzs" "/data/adb/"
chmod 777 "/data/adb/7zzs"
/data/adb/7zzs a -r -mx=9 "$current_dir"/output.7z "$current_dir"/files/* 
rm -rf "$current_dir"/files/*
/data/adb/7zzs a -r "$current_dir"/ARMIAS.zip "$current_dir"/*
rm -rf "$current_dir"/prebuilts/
rm -rf "$current_dir"/files/
rm -rf "$current_dir"/customize.sh
rm -rf "$current_dir"/META-INF/
rm -rf "$current_dir"/settings/
rm -rf "$current_dir"/languages.ini
rm -rf "$current_dir"/service.sh
rm -rf "$current_dir"/output.7z
rm -rf "$current_dir"/backup_all_modules.sh
if [ $? -eq 0 ]; then
    echo "Successfully created archive: $current_dir/output.7z"
else
    echo "Failed to create archive for directory: output.7z"
fi
rm -f "/data/adb/7zzs"
