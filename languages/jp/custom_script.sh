#カスタムスクリプトの編集を歓迎！
#このスクリプトはデフォルトスクリプトと設定スクリプトの変数と関数を継承し、直接呼び出し可能です

#以下の関数を実行する変数をカスタマイズ可能
#Aurora_ui_print "印刷内容"
#この関数はui_printより美しくなります
#$ZIPLIST下のモジュールを巡回インストールするinitialize_install
#ループについては言及の必要はありません、ご自身で追加をお願いします
#巡回修正パッチを実行するpatches_install
###################################
#単一モジュールのインストール例
#Installer "path/to/module.zip"

#互換性モードを呼び出す
#Installer_Compatibility_mode "path/to/module.zip"
###############################
#音量キーでモジュールをインストールする例 $1は上キーでインストールするモジュール $2は下キーでインストールするモジュール $3は上キーモジュール名 $4は下キーモジュール名 -モジュール名は省略可
#もしモジュール名を省略した場合、音量上キーでxxxモジュールをインストール、音量下キーでxxxモジュールをインストールのヒントを出力しません
#key_installer "path/to/module.zip" "path/to/module.zip" "モジュール名" "モジュール名"

#また音量キー検出関数を呼び出すこともできます
#key_select
#検出結果は$key_pressed変数にあります
###################################
#magisk_installer "path/to/module.zip"
#apd_installer "path/to/module.zip"
#ksu_installer "path/to/module.zip"
#ターゲット環境に存在するかどうかを検出し、存在する場合はインストールを実行、存在しない場合は実行しません
###################################
#パッチモジュール例

#モジュールのパッチを格納するディレクトリ
PATCHMOD="patches/modules"
#~/patches/modules/フォルダを作成してください

#cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules_update/"

#もしモジュールにパッチを当てたい場合は、上の行の#を削除してください
#パッチモジュールのパスは通常は/data/adb/modules_update/
#パッチのルール：~/patches/modules/ディレクトリ下のファイルをdata/adb/modules_update/にコピーする
#ので、~/patches/modules/ディレクトリ下にインストールモジュールのidと同じ名前のフォルダを作成し、パッチを当てたいファイルをそのフォルダに入れてください

#既にインストールされたモジュールにパッチを当てる例
#cp -r "$MODPATH/$PATCHMOD"/* "$SECURE_DIR/modules/"

#このスクリプト内でexitとabort関数を使用しないでください
