
=begin
  共通処理に必要なワードを列挙。
  prefix系とsuffix系は
  仮想人格側には実装していなくても動作するようにする予定。

=end
module Juliest::Common_Word
  # Juliest バージョン
  VERSION = '__version__'
  # 利用者の名前
  OWNER_NAME = '__owner_name__'
  # 仮想人格の名前
  PERSONA_NAME = '__persona_name__'
  # 仮想人格のバージョン
  PERSONA_VERSION = '__persona_version__'
  # 仮想人格の製作者
  PERSONA_CREATOR = '__persona_creator__'
  # 仮想人格のコピーライト
  PERSONA_COPYLIGHT = '__persona_copylight__'
  # 仮想人格のライセンス
  PERSONA_LICENSE = '__persona_license__'
  # 利用者へ問いかけるときの前文
  ASK_TO_PREFIX = '__ask_to_prefix__'
  # 利用者へ問いかけるときの後文
  ASK_TO_SUFFIX = '__ask_from_sufficx__'
  # 利用者へ問いかける
  ASK_TO = '__ask_to__'
  # 利用者から問いかけられるときの前文
  ASK_FROM_PREFIX = '__ask_from_prefix__'
  # 利用者から問いかけられるときの後文
  ASK_FROM_SUFFIX = '__ask_from_suffix__'
  # 利用者から問いかけられる
  ASK_FROM = '__ask_from__'
  # 利用者への確認メッセージの前文
  CONFIRM_PREFIX = '__confirm_prefix__'
  # 利用者への確認メッセージの後文
  CONFIRM_SUFFIX = '__confirm_suffix__'
  # 利用者への確認メッセージ
  CONFIRM = '__confirm__'
  # 利用者へ待機を願い出るときの前文
  WAIT_TO_PREFIX = '__wait_to_prefix__'
  # 利用者へ待機を願い出るときの後文
  WAIT_TO_SUFFIX = '__wait_to_suffix__'
  # 利用者へ待機を願い出る
  WAIT_TO = '__wait_to__'
  # 利用者から待機を命じられるときの前文
  WAIT_FROM_PREFIX = '__wati_from_prefix__'
  # 利用者から待機を命じられるときの後文
  WAIT_FROM_SUFFIX = '__wati_from_suffix__'
  # 利用者から待機を命じられる
  WAIT_FROM = '__wait_from__'
  # 仮想人格が自分を示す際の代名詞
  SELF_SYNONYMOUS = '__self_synonymous__'
  # 仮想人格が利用者を示す際の代名詞
  OWNER_SYNONYMOUS = '__owner_synonymous__'
  # 実行するときの前文
  EXECUTE_PREFIX = '__execute_prefix__'
  # 実行するときの後文
  EXECUTE_SUFFIX = '__execute_suffix__'
  # 実行する
  EXECUTE = '__execute__'
  # 完了するときの前文
  COMPLETE_PREFIX = '__complete_prefix__'
  # 完了するときの後文
  COMPLETE_SUFFIX = '__complete_suffix__'
  # 完了する
  COMPLETE = '__complete__'
  # モード
  MODE = '__mode__'
  # サイレント
  SILENT = '__silent__'
  # モードの活性化
  ACTIVATE = '__activate__'
  # モードの非活性化
  DEACTIVATE = '__deactivate__'
  # 開始
  START = '__start__'
  # 終了
  STOP = '__stop__'
  # 話す
  TALK = '__talk__'
  # 引数
  ARGUMENT = '__argument__'
  # 了解するときの前文
  OK_PREFIX = '__ok_prefix__'
  # 了解するときの後文
  OK_SUFFIX = '__ok_suffix__'
  # 了解する
  OK = '__ok__'
  # 断るときの前文
  NG_PREFIX = '__ng_prefix__'
  # 断るときの後文
  NG_SUFFIX = '__ng_suffix__'
  # 断る
  NG = '__ng__'
  # エラーのときの前文
  ERROR_PREFIX = '__error_prefix__'
  # エラーのときの後文
  ERROR_SUFFIX = '__error_suffix__'
  # エラー
  ERROR = '__error__'
  # 認識できなかったため、再入力を願い出るときの前文
  RE_INPUT_PREFIX = '__re_input_prefix__'
  # 認識できなかったため、再入力を願い出るときの後文
  RE_INPUT_SUFFIX = '__re_input_suffix__'
  # 認識できなかったため、再入力を願い出る
  RE_INPUT = '__re_input__'
end


