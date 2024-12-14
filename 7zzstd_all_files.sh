current_dir=$(pwd)
temp_dirs=("/tmp" "/var/tmp" "/Temp" "/Users/*/Library/Caches" "/storage/emulated/0/Android/data/bin.mt.plus/temp")
for dir in "${temp_dirs[@]}"; do
    if [[ $current_dir == $dir* ]]; then
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        echo "当前目录是临时目录或其子目录。请解压到其他目录再执行脚本"
        exit 0
    fi
done
"MODDIR/7zzs" a -mx9 "$current_dir"/files/* "$current_dir"/output.7z
    if [ $? -eq 0 ]; then
        echo "Successfully created archive: $OUTPUT_FILE"
    else
        echo "Failed to create archive for directory: $DIR_NAME"
    fi