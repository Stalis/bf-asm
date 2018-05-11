#!/usr/bin/env ruby

# class of Compiler
class Compiler
  attr_reader :result
  def initialize
    @result = ''
    @lines = []
    @tokens = []
    @allow_add_lines = true
  end

  def compile(lines)
    @result = translate tokenize(lines)
  end

  def parse(lines)
    (lines.map do |line|
      cmd = line.split(';')[0]
      unless cmd.nil?
        cmd.chomp!
        cmd.rstrip!
      end
      cmd
    end).delete_if { |line| line.nil? || line.empty? }
  end

  def tokenize(lines)
    # translate lines to tokens like:
    # copy(1,2) ->
    #   {'type' => 'operator', 'command' => 'copy', 'args' => ['1', '2']}
    #
    # #inline *bf_code* ->
    #   {'type' => 'inline', 'body' => { 'code' => *bf_code* } }
    #
    # loop
    #  *code*
    # endloop ->
    #   {'type' => 'cycle', 'body' => { 'content' => [*tokens*] }}
    tokens = []

    tokens
  end

  def translate(tokens)
    tokens
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
    puts c.parse(lines)

    # puts c.result
    # File.open(ARGV[0].split('.')[0] + '.bf', 'w+') do |file|
    #   file.puts c.result
    # end
  end
end
