#!/usr/bin/ruby -Ku
#-*- encoding :utf-8 -*-
# -Ku は非推奨ですが。下位互換のために付与
#$LOAD_PATH << File.dirname(__FILE__)

=begin
  AqKanji2Koe ラッパーライブラリ
  漢字を含む文字列から、AquesTalk2音声記号文字列へ変換して返す。

  Usage
    require 'aqkanji2koe'

    k2k = AqKanji2Koe.new
    source = "いい天気ですね。"
    koe = k2k.convert(source)

=end


# Ruby バージョン毎に処理を分岐。
case
  # Ruby 1.9, 1.8 では 'dl/import'
  when RUBY_VERSION.match(/1\.9/), RUBY_VERSION.match(/1\.8\.7/)
    require 'dl/import'
  # Ruby 2.x では 'fiddle/import'
  when RUBY_VERSION.match(/2\.\d/)
    require 'fiddle/import'
end

module LibAqKanji2Koe
  LIB_PATH = 'lib'

  # Ruby バージョン毎に処理を分岐。
  case
    # Ruby 1.9, 1.8.7 では DL::Importer
    when RUBY_VERSION.match(/1\.9/)#, RUBY_VERSION.match(/1\.8\.7/)
      extend DL::Importer
    # Ruby 2.x では Fiddle::Importer
    when RUBY_VERSION.match(/2\.\d/)
      extend Fiddle::Importer
    # Ruby 1.8.7 older では DL::Importable
    else
      extend DL::Importable
  end
  
  # 2014-03-26 BUG対応
  dlload 'libstdc++.so.6'
  
  # AquesKanji2Koe 評価版(linux)
  # dlload LIB_PATH+'/libAqKanji2KoeEva.so.2.0'

  # AquesKanji2Koe 開発用(linux)
   dlload LIB_PATH+'/libAqKanji2Koe.so.2.0'


  # AqKanji2Koe(pathDict, pErr)
  # インスタンスハンドラ生成
  @@create = extern('viod * AqKanji2Koe_Create(const char *, int *)', :stdcall)
  
  # AqKanji2Koe_Convert(hAqKanji2Koe, kanji, koe, nBufKoe)
  @@convert = extern('int AqKanji2Koe_Convert(void *, const char *, char *, int)', :stdcall)
  
  # AqKanji2koe_Release(hAqKanji2Koe)
  # メモリ解放を行う処理
  @@release = extern('void AqKanji2Koe_Release(void *)', :stdcall)
end

# エラークラス
class AqKanji2Koe_Error < StandardError; end

# AqKanji2Koe ライブラリのラッパークラス
class AqKanji2Koe
  include LibAqKanji2Koe

  # 辞書ファイルのパス
  DICT_PATH            = 'dict/aq_dic_large'
  # 音声記号ファイルのファイルサイズ倍率指定
  OUTPUT_MAGNIFICATION =                   7
  
  # 辞書ファイルパスアクセサ
  attr_accessor :dict_path
  # 音声記号ファイルのファイルサイズ倍率指定アクセサ
  attr_accessor :output_magnitication
  # 出力ファイル名アクセサ
  attr_accessor :output
  # インスタンスハンドラ
  attr_accessor :handler

  # 引数なしでインスタンス生成された場合、初期値を用いる
  def initialize(dict_path = nil, output_magnitication = nil)
    dict_path             ||= DICT_PATH
    output_magnitication  ||= OUTPUT_MAGNIFICATION
    @dict_path              = dict_path
    @output_magnitication   = output_magnitication
  end

  # ハンドラを生成
  def create(dict_path = nil)
    dict_path ||= @dict_path
    handler     = nil
    null_ptr    = nil

    # Ruby バージョンで分岐
    case
      when RUBY_VERSION.match(/1\.9/), RUBY_VERSION.match(/1\.8\.7/)
        null_ptr = DL::CPtr[0]
        
      when RUBY_VERSION.match(/2\.\d/)
        null_ptr = Fiddle::Pointer[0]
    end
    
    begin
      perr = [0].pack('i!')
      handler = @@create.call(dict_path, perr)
      perr = perr.unpack('i!')
      raise('AquesKanji2Koe Error: '+perr.first.to_s) if handler.eql?(null_ptr)
    rescue AquesKanji2Koe_Error => error
      p error.inspect
      return false
    end
    
    @handler = handler
    return true
  end
  
  # テキストを音声記号へ変換する処理( AqKanji2Koe ライブラリのラッパーメソッド )
  def convert(input, output = nil, output_magnitication = nil, handler = nil)
    begin
      raise(AqKanji2Koe_Error.new('input arg required.')) unless input
    rescue AqKanji2Koe_Error => error
      p error.inspect
      return false
    end
    
    # ハンドラが生成されていない場合は生成する
    if @handler.nil? then
      create
    end

    input.chomp!
    output_magnitication ||= @output_magnitication
    handler              ||= @handler

    # 最低256バイト以上になるように、入力元バイトサイズの数倍を確保
    n_buf_koe = input.bytesize * 256 * output_magnitication
    # 漢字含む入力領域を確保
    kanji = input
    # バッファ込みの出力領域を確保
    koe = " "*n_buf_koe

    begin
      result = @@convert.call(handler, kanji, koe, n_buf_koe)

      # 余計な空白を削除。
      koe.strip!

      raise(AqKanji2Koe_Error.new(
        'AqKanji2Koe error: '+result.to_s)
      ) unless result.zero?
    rescue AqKanji2Koe_Error => error
      p error.inspect
      return false
    end

    release(handler)

    unless output then
      open(output, 'w+b'){|f|f.print(koe)}
      return true
    else
      return koe
    end
  end
  
  # メモリ解放を行う処理のラッパーメソッド
  def release(handle)
    @@release.call(handle)
  end
end

