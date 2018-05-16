#!/usr/bin/env ruby

require_relative 'lib/tokenizer'
require_relative 'lib/translator'

# class of Compiler
class Compiler
  attr_reader :result
  def initialize
    @result = ''
    @lines = []
    @tokens = []
  end

  def compile(lines)
    @result = translate tokenize parse lines
  end

  def parse(lines)
    (lines.map do |line|
      cmd = line.split(';')[0]
      unless cmd.nil?
        cmd.chomp!
        cmd.rstrip!
      end
      cmd.reverse.strip.reverse
    end).delete_if { |line| line.nil? || line.empty? }
  end

  def tokenize(lines)
    Tokenizer.tokenize(lines)
  end

  def translate(tokens)
    Translator.translate(tokens)
  end
end

if $PROGRAM_NAME == __FILE__
  unless ARGV.empty?
    lines = []
    File.open(ARGV[0]).each do |line|
      lines << line
    end

    c = Compiler.new
    # puts c.compile(lines)
    # puts c.parse(lines)

    c.compile(lines)

    puts c.result
    if ARGV[1].nil?
      File.open(ARGV[0].split('.')[0] + '.bf', 'w+') do |file|
        file.puts c.result
      end
    else
      File.open(ARGV[1], 'w+') do |file|
        file.puts c.result
      end
    end
  end
end
