#!/system/bin/sh

# カスタムスクリプト
# -----------------
# このスクリプトはデフォルトスクリプトとセットアップスクリプトをベースに拡張し、その中の変数と関数を直接使用可能になっています。

# $MODPATHの未指定のデフォルト呼び出しは自動的に前方に$MODPATHを追加しますので、手動で追加する必要はありません。
# $MODPATHは任意のパスに置き換え可能ですが、パスの正確性を確保してください。

# カスタム機能概要
# --------------
# 1. 美しい印刷：Aurora_ui_print "印刷する内容"を使って美しい内容の展示を行います。
# 2. モジュールのインストール：initialize_install "$MODPATH/フォルダパス"関数を通じて、ターゲットディレクトリ下の全てのモジュールの自動インストールが可能です。
# 3. パッチのインストール：patches_install関数は全てのパッチを巡回し、インストールを行います。

# 例：単一モジュールのインストール
# -----------------
# Installer "$MODPATH/モジュールパス.zip" #指定のモジュールをインストールします。
# 特定のroot方案に対し、Installer "$MODPATH/モジュールパス.zip" "KSUまたはAPATCHまたはmagisk"を使い、ターゲット環境を検出した時自動的にインストールを実行、さもなくばインストールを実行しません。

# 例：互換性モードのインストール
# ----------------
# 互換性モード下でモジュールをインストールする必要がある場合、Installer_Compatibility_mode "$MODPATH/モジュールパス.zip"を使用してください。

# 例：単一ファイルの解凍
# ----------------
# un7z "解凍するファイル名" "宛先フォルダー" # 指定したファイルを解凍します。
# 例：音量鍵を使ってインストールモジュールの選択
# ---------------------
# key_installer "$MODPATH/上鍵モジュールパス.zip" "$MODPATH/下鍵モジュールパス.zip" "印刷する上鍵モジュール名" "印刷する下鍵モジュール名" #音量鍵を使ってインストールのモジュールを選択します。
# モジュール名を記入しない場合、インストール時相関ヒントを表示しません。

# 例：Github倉庫から最新のreleaseファイルリンクの取得
# github_get_url "倉庫作者/倉庫名称" "releaseに含まれる必要のあるファイル名"
# 出力リンクアドレスは$DESIRED_DOWNLOAD_URL変数にあります

# 例：単一ファイルのダウンロード
# download_file "ファイルリンク"

# 例：音量鍵選択の検出
# ------------------
# key_select #呼び出し後、$key_pressed変数を通じてユーザの音量鍵を通じた選択結果の取得が可能です。

# 任意のパッチ
# patch_default "$MODPATH" "もとのパス" "パッチパス"
# もちろん$MODPATHを任意のパスに置き換える事が可能で、モジュール外のパスを呼び出す事ができます

# 例：既にインストールされたモジュールのパッチ
# -----------------
# 既にインストールされたモジュールにパッチを適用する必要がある場合、以下のコマンドを使用可能です：
# cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules/"

# 例：複数のファイルを/data/adb/に移動
# -----------------
# mv_adb "フォルダパス"

# 例：magiskのdenylistへの追加
# -----------------
# magisk_denylist_add "ソフトウェアパッケージ名" #magiskのみ対応

# 例：bootパーティションの書き込み
# -----------------
# aurora_flash_boot "ファイルパス"

# 注意事項
# ------
# このスクリプト内でexit及びabort関数の使用を避け、スクリプト実行の意外な中断を防ぎてください。