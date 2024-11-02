#!/bin/bash
#パスは$MODPATH下にあります
#zipモジュールを格納するディレクトリ
ZIPLIST="modules"

#パッチモジュールに未知の問題が存在します（Magiskは問題なし）、廃止済みです、使用を希望する場合は自分でカスタムスクリプトを編集してください

#パッチDATAを格納するディレクトリ
PATCHDATA="patches/data"
#パッチsdcardを格納するディレクトリ
PATCHSDCARD="patches/sdcard"
#APKをインストールするディレクトリ（非システムアプリ）
PATCHAPK="patches/apks"
#ユーザスペースのパス
SDCARD="/storage/emulated/0"

#上級者向け設定
#言語設定
langpath="languages.txt"
print_languages="jp"
#互換性モードでモジュールをインストール、非必要の時はオンにしないでください
Installer_Compatibility="false"
#カスタムスクリプトを有効にするかどうか
CustomScript="false"
#カスタムスクリプトのパス
CustomScriptPath="custom_script.sh"
####################################
#ここにカスタム変数を追加可能
####################################

#magiskの最小バージョン
magisk_min_version="25400"

#ksuの最小互換性バージョン
ksu_min_version="11300"
#ksuの最小互換性カーネルバージョン
ksu_min_kernel_version="11300"
#ksuの最小正常バージョン
ksu_min_normal_version="99999"

#apatchの最小互換性バージョン
apatch_min_version="10657"
#apatchの最小正常バージョン
apatch_min_normal_version="10800"

#アンドロイドAPIの最小バージョン
ANDROID_API="30"
