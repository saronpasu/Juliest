# 開発者向けドキュメント
---

## これは何？
* 製作者が記載した、開発者向けの資料です。

---
## 開発メモ
* このリポジトリには julius は含まれていません。
    * install_julius.sh を実行し、 Julius を導入して下さい。
* このリポジトリには AquesTalk2 AqKanji2Koe ライブラリ は含まれていません。
    * [アクエスト社サイト](http://www.a-quest.com/products/aquestalk.html) より、AquesTalk2 AqKanji2Koe Linux評価版 をダウンロードするか。
    * 同社より、開発版ライセンスをお買い求め下さい。
* このリポジトリには MPlayer は含まれていません。
    * apt-get install mplayer などで導入して下さい。
* Ubuntu でマイク入力する際には、 libasound2-dev が必要です。
    * apt-get libasound2-dev などで導入して下さい。
* Ubuntu でマイク入力する際に、音が小さく、ノイズが多くてうまく認識されないことがあります。
    * GNOME ALSA Mixser を導入して、 Master ボリュームを上げて下さい。
    * apt-get gnome-alsamixer などで導入できます。
* Ruby で実行しています。推奨バージョンは2.0系です。

---
## 依存しているミドルウェア/ライブラリ
* Julius 音声認識エンジン
* AquesTalk2 音声合成ライブラリ
* AqKanji2Koe 漢字含むテキストの音声記号変換ライブラリ
* Rack Webサーブレット
* Puma Webサーブレット
* MessagePack ライブラリ
* Julius ラッパーライブラリ

---
## 大まかな処理内容
* Julius,AquesTalk2,Juliestをそれぞれサーブレットとしてローカル起動します
* マイク入力(ALSA)から、音声入力を受けます。
* Juliusが音声認識をし、Juliusサーブレットへ渡します
* JuliusサーブレットからJuliestサーブレットへ通信されます
* JuliestサーブレットがJuliest内部パーサへ入力内容を渡します
* Juliestパーサが解析結果に従い、処理を行います。
* Juliestサーブレットが、AquesTalk2サーブレットへ通信します
* AquesTalk2サーブレットが音声合成し、MPlayerを実行して音声を再生します
* AquesTalk2サーブレットがJuliestサーブレットへ結果を返します


* と、このような形で。基本的にはローカルに立てられたサーブレット間でMessagePackによる通信を行い処理しています。
* こうすることで、常に音声認識エンジンを稼働させることができ。
* また、音声合成エンジンで音声を再生中でも処理を継続することが可能です。

* 大まかに言うと [*マイク入力*]->[*Julius*]->[*Juliest*]->[*AquesTalk*]->[*MPlayer*]->[*スピーカー出力*] この流れです。

---
## ファイル構成について
* さまざまなファイルで更生されていますが。大まかに解説します。


* README.md
    * 解説ファイル
* config.yaml
    * 設定ファイル
* default_config.yaml
    * 初期設定ファイル
* install_julius.sh
    * Julius インストールスクリプト
* install_aquestalk2_eva.sh
    * AquesTalk2/AqKanji2Koe 評価版 インストールスクリプト
* startup_servlet.sh
    * サーブレットの一括起動スクリプト
* stop_servlet.sh
    * サーブレットの一括終了スクリプト
* log
    * ログ用ディレクトリ
* data
    * ユーザデータ用ディレクトリ
* rack
    * サーブレット用ディレクトリ
* lib
    * ライブラリ、コアスクリプトなどが入っているディレクトリ
    * AquesTalk2 AqKanji2Koe ライブラリはこのディレクトリへ配置して下さい
* bin
    * 実行ファイル用ディレクトリ
* dict
    * AqKanji2Koe 辞書ファイル用ディレクトリ
* plugins
    * プラグイン用ディレクトリ
    * 開発者や、ユーザが独自にカスタマイズしたプラグインを導入することを想定しています。
* persona
    * 仮想人格エージェント用ディレクトリ
    * 開発者や、ユーザが独自にカスタマイズしたペルソナを導入することを想定しています
* parser
    * 入力文、出力文のパーサ用ディレクトリ
    * 入力文や出力文の正規表現置換などで独自にカスタマイズを行うことを想定しています
* doc
    * さまざまな解説ドキュメントのディレクトリ


* 基本的に、 lib 配下にメインのプログラムが入っています。
* プログラムコード中にコメントをできるだけ記載しますので。詳細はコメントで確認下さい。
* 開発版は CUI での動作を想定しています。
* メジャーリリースには設定用の GUI を標準で備える予定です。

---
## 開発コミュニティについて
* まだ、開発者単独なので。特にありません。
* Twitter などでご連絡いただけると反応します。

---
## Ubuntu 以外のサポートについて
* そもそも。Ubuntu で動作することが当面の目的です。
* 評判が良ければ、開発者を募ってWindows版やOSX版を開発したいですね。


[*最終更新: 2014-03-27*]
