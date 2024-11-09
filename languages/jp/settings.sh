# 脚本の設定パラメータ

# モジュールの格納のベースパス
# MODPATH

# 各ディレクトリのパス定義
ZIPLIST="/modules"                     # zipモジュールの格納ディレクトリ
PATCHDATA="/patches/data"              # パッチDATAの格納ディレクトリ
PATCHSDCARD="/patches/sdcard"          # パッチsdcardの格納ディレクトリ
PATCHAPK="/patches/apks"               # APKのインストール格納ディレクトリ（非システムアプリ）
SDCARD="/storage/emulated/0"           # ユーザースペースsdcardのパス
PATCHMOD="/patches/modules"            # パッチモジュールの格納ディレクトリ
CustomScriptPath="/custom_script.sh"   # カスタムスクリプトのパス

# 高度な設定
langpath="languages.txt"               # 言語設定ファイルのパス
print_languages="jp"                   # 既定で印刷する言語
Installer_Compatibility=false          # モジュールのインストールに互換性モードを有効にするか（必要でない限り推奨しない）
Installer_Log=true                     # モジュールのインストールを記録するか
CustomScript=false                     # カスタムスクリプトを有効にするか

# ユーザ定義変数エリア（必要に応じてより多くの変数を追加可）

# Magisk及び関連したコンポーネントのバージョン要件
magisk_min_version="25400"             # 必要なMagiskの最低バージョン
ksu_min_version="11300"                # 必要なKernelSUの最低互換性バージョン
ksu_min_kernel_version="11300"         # 必要なKernelSUの最低互換性カーネルバージョン
ksu_min_normal_version="99999"         # 通常使用に必要なKernelSUの最低バージョン
apatch_min_version="10657"             # 必要なAPatchの最低互換性バージョン
apatch_min_normal_version="10832"      # 通常使用に必要なAPatchの最低バージョン
ANDROID_API="30"                       # 必要な最低Android APIバージョン