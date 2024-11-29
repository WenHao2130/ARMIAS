# 脚本配置パラメータ

# 模块の基本保存パス
# MODPATH

print_languages="zh"                   # デフォルトの印刷言語
# 各ディレクトリのパス定義
ZIPLIST="/modules"                     # zip模块の保存ディレクトリ
PATCHDATA="/patches/data"              # パッチDATAの保存ディレクトリ
PATCHSDCARD="/patches/sdcard"          # パッチsdcardの保存ディレクトリ
PATCHAPK="/patches/apks"               # APKのインストールディレクトリ（非システムアプリ）
SDCARD="/storage/emulated/0"           # ユーザーステートsdcardのパス
PATCHMOD="/patches/modules"            # パッチ模块の保存ディレクトリ
CustomScriptPath="/custom_script.sh"   # カスタムスクリプトのパス
langpath="/languages.txt"              # 言語設定ファイルのパス
download_destination="/$SDCARD/Download/AuroraNasa_Installer" # ダウンロードパス
max_retries="3"                       # ダウンロードの再試行回数

# 上級者向け設定
Download_before_install=false          # モジュールのインストール前にネットワークからダウンロードしてインストールするかどうか
Installer_Compatibility=false          # モジュールのインストールに互換性モードを有効にするかどうか（不必要な時は有効にしないでください）
Installer_Log=true                     # モジュールのインストールのログを記録するかどうか
CustomScript=false                     # カスタムスクリプトを有効にするかどうか
fix_ksu_install=false                  # KernelSUのインストール問題を試み修復するかどうか（不必要な時は有効にしないでください、有効にしたら動作が遅くなり、または不明な問題が起こる可能性がある）
delayed_pattern="*Shamiko*"            # 遅延インストールを必要なファイル名を定義

# ユーザカスタム変数エリア（必要に応じて更に多くの変数を追加）

# Magisk及び関連コンポーネントのバージョン要求
magisk_min_version="25400"             # 要求のMagiskの最低バージョン
ksu_min_version="11300"                # 要求のKernelSUの最低互換性バージョン
ksu_min_kernel_version="11300"         # 要求のKernelSUの最低互換性カーネルバージョン
ksu_min_normal_version="99999"         # 要求のKernelSUの通常使用の最低バージョン
apatch_min_version="10657"             # 要求のAPatchの最低互換性バージョン
apatch_min_normal_version="10832"      # 要求のAPatchの通常使用の最低バージョン
ANDROID_API="30"                       # 要求の最低アンドロイドAPIバージョン

# ダウンロードリンク （必要に応じて更に多くのリンクを追加）
LINKS_1=""
LINKS_2=""