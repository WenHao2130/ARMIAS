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
if [[ $SHELL != *"su"* ]]; then
    echo "错误：此脚本必须通过su执行。" >&2
    exit 1
fi
echo "脚本正在以su执行，继续执行后续操作..."
cp "$current_dir/7zzs" "/data/adb/"
chmod 777 "/data/adb/7zzs"
/data/adb/7zzs a -r -mx9 "$current_dir"/output.7z "$current_dir"/files/*
if [ $? -eq 0 ]; then
    echo "Successfully created archive: $current_dir/output.7z"
else
    echo "Failed to create archive for directory: output.7z"
fi
rm -f "/data/adb/7zzs"
