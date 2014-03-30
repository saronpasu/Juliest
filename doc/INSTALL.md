# INSTALL
---

## これは何？
---

* インストール用のドキュメントです

### 開発版

* 開発版は、 git リポジトリより取得をお願いします
    * $ git clone https://github.com/saronpasu/Juliest.git
* Julius のインストール
    * $ chmod +x install_julius.sh
    * $ ./install_julius.sh
* AquesTalk2/AqKanji2Koe 評価版のインストール
    * $ chmod +x install_aquestalk2_eva.sh
    * $ ./install_aquestalk2_eva.sh
* log ディレクトリの作成
    * $ mkdir log
* lib/aquestalk2.rb の書き換え
    * 開発版から評価版のライブラリを呼び出すようにコメントアウトを書き換えて下さい。
* lib/aqkanji2koe.rb の書き換え
    * 開発版から評価版のライブラリ/辞書を呼び出すようにコメントアウトを書き換えて下さい。
* サーブレット開始/終了スクリプトの実行権限を変更
    * $ chmod +x startup_servlet.sh
    * $ chmod +x stop_servlet.sh
* MessagePack インストール
    * $ gem install msgpack
* Puma インストール
    * $ gem install puma


### 安定版

* まだ、リリースされていません。
* 将来的にはリリースページから、プラットフォーム毎にリリースされているものをダンロードし、導入します。


[*最終更新: 2014-03-27*]

