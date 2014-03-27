#!/usr/bin/ruby -Ku
#-*- encoding :utf-8 -*-
# -Ku は非推奨ですが。下位互換のために付与
#$LOAD_PATH << File.dirname(__FILE__)

=begin
  AquesTalk2 ラッパーライブラリ
  phont ファイル指定には未対応です。

  Usage:
    require 'aquestalk2'
    
    aqtk2 = AquesTalk2.new
    source = 'こんにちわ'
    output = 'output.wav'
    aqtk2.synthe(source, output)

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

module LibAquesTalk2
  LIB_PATH = 'lib'

  # Ruby バージョン毎に処理を分岐。
  case
    # Ruby 1.9, 1.8.7 では DL::Importer
    when RUBY_VERSION.match(/1\.9/), RUBY_VERSION.match(/1\.8\.7/)
      extend DL::Importer
    # Ruby 2.x では Fiddle::Importer
    when RUBY_VERSION.match(/2\.\d/)
      extend Fiddle::Importer
    # Ruby 1.8.7 older では DL::Importable
    else
      extend DL::Importable
  end
  
  # AquesTalk2 評価版(linux)
  # dlload LIB_PATH+'/libAquesTalk2Eva.so.2.3'

  # AquesTalk2 開発用(linux)
  dlload LIB_PATH+'/libAquesTalk2.so.2.3'


  # AquesTalk2_Synthe_Utf8(koe, iSpeed, size, phontDat)
  # 音声変換を行う処理
  @@synthe = extern('unsigned char *  AquesTalk2_Synthe_Utf8(const char *, int, int *, void *)', :stdcall)

  # AquesTalk2_FreeWave(*wav)
  # メモリ解放を行う処理
  @@free_wave = extern('void AquesTalk2_FreeWave(unsigned char *)', :stdcall)
end

# エラークラス
class AquesTalk2_Error < StandardError; end

# AquesTalk2 ライブラリのラッパークラス
class AquesTalk2
  include LibAquesTalk2

  # 読み上げ速度の初期値
  DEFAULT_ISPEED =         100
  # 音声話者の初期値
  DEFAULT_PHONT  =           0
  # 出力ファイル名の初期値
  DEFAULT_OUTPUT = 'output.wav'
  
  # 読み上げ速度アクセサ
  attr_accessor :ispeed
  # 読み上げ話者アクセサ
  attr_accessor :phont
  # 出力ファイル名アクセサ
  attr_accessor :output

  # 引数なしでインスタンス生成された場合、初期値を用いる
  def initialize(ispeed = nil, phont = nil)
    ispeed ||= DEFAULT_ISPEED
    phont  ||= DEFAULT_PHONT
    @ispeed = ispeed
    @phont  = phont
  end
  
  # テキストを音声へ変換する処理( AquesTalkライブラリのラッパーメソッド )
  def synthe(input, output = nil, ispeed = nil, phont = nil)
    begin
      raise(AquesTalk2_Error.new('input arg required.')) unless input
    rescue AquesTalk2_Error => error
      p error.inspect
      return false
    end
    
    input.chomp!
    output ||= DEFAULT_OUTPUT
    ispeed ||= @ispeed
    phont  ||= @phont

    begin
      size = [0].pack('i!')
      result = @@synthe.call(input, ispeed, size, phont)
      size = size.unpack('i!')

      null_ptr = nil
      case
        when RUBY_VERSION.match(/1\.9/), RUBY_VERSION.match(/1\.8\.7/)
          null_ptr = DL::CPtr[0]
        when RUBY_VERSION.match(/2\.\d/)
          null_ptr = Fiddle::Pointer[0]
      end

      raise(AquesTalk2_Error.new('AquesTalk2_Synthe_Utf8 error: '+size.to_s)) if result.eql?(null_ptr)
    rescue AquesTalk2_Error => error
      p error.inspect
      return false
    end

    wav = result[0, size.first]
    open(output, 'w+b'){|f|f.print(wav)}


    free_wave(wav)
    return true
  end
  
  # メモリ解放を行う処理のラッパーメソッド
  def free_wave(wav)
    @@free_wave.call(wav)
  end
end

