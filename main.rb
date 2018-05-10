#!/usr/bin/env ruby
#
# ASM for BrainFuck
#
# @(k) or shift(k) -> shift for k cells
# inc(k) -> increment current cell for k times
# dec(k) -> decrement current cell for k times
# set(v) -> set v to current cell
# zero() -> clear current cell
# add(k) -> add current cell value to (current + k) cell
# mov(k) -> move current cell value to (current + k) cell
# copy(k, t) -> copy current cell value to (current + k) cell, 
# using (current + k + t) cell
#
# Coming soon:
# - Macroses
# - Repeating and looping macroses
#
# class of BrainFuck Assembler Compilator
class Compiler
  attr_reader :result
  def initialize
    @result = ''
  end

  def parse_command(line)
    translate(line.split(';')[0])
  end

  private

  # @tokens = {
  #   '@' => shift,
  #   'shift' => shift,
  #   'inc' => inc,
  #   'dec' => dec,
  #   'set' => set,
  #   'zero' => zero,
  #   'add' => add,
  #   'mov' => mov,
  #   'copy' => copy,
  #   'scan' => scan,
  #   'print' => print
  # }

  def translate(command_line)
    line = command_line.split('(')
    cmd = line[0]
    puts('cmd: ' + (cmd.nil? ? 'nil' : cmd))
    args = line[1].split(',').map { |item| item.chomp.chomp(')') }
    puts('args: ' + (args.nil? ? 'nil' : args.to_s))
    res = ''

    case cmd
    when '@'
      res += shift(args[0].to_i)
    when 'shift'
      res += shift(args[0].to_i)
    when 'inc'
      res += inc(args[0].to_i)
    when 'dec'
      res += dec(args[0].to_i)
    when 'set'
      res += set(args[0].to_i)
    when 'zero'
      res += zero
    when 'add'
      res += add(args[0].to_i)
    when 'mov'
      res += mov(args[0].to_i)
    when 'copy'
      res += copy(args[0].to_i, args[1].to_i)
    when 'scan'
      res += scan
    when 'print'
      res += print
    end
    puts('res: ' + (res.nil? ? 'nil' : res))
    @result += res
    puts('result: ' + @result)
  end

  def repeat(k, action)
    res = ''
    k.times { res += action }
    res
  end

  def inc(k)
    repeat(k, '+')
  end

  def dec(k)
    repeat(k, '-')
  end

  def set(v)
    zero + inc(v)
  end

  def shift(k)
    res = ''
    if k > 0
      k.times { res += '>' }
    elsif k < 0
      (-k).times { res += '<' }
    end
    res
  end

  def zero
    cycle(dec(1))
  end

  def add(k)
    cycle(dec(1) + shift(k) + inc(1) + shift(-k))
  end

  # move current value to another memory cell
  # k - shift from current to target cell
  def mov(k)
    shift(k) + zero + shift(-k) + add(k)
  end

  # copy current value to another memory cell
  # k - shift from current to target cell
  # t - shft from target to temporary cell
  def copy(k, t)
    preparing = shift(k) + zero + shift(t) + zero + shift(-k - t)
    copying = cycle(dec(1) + shift(k) + inc(1) + shift(t) + inc(1) + shift(-k - t))
    clearing = shift(k + t) + mov(-k - t)
    preparing + copying + clearing
  end

  def if_else(t, true_action, false_action)
    preparing = shift(t) + zero + inc(1) + shift(-t)
    if_branch = cycle(true_action + shift(t) + zero + shift(-t) + zero)
    else_branch = shift(t) + cycle(shift(-t) + false_action + shift(t) + zero)
    clearing = shift(-t)
    preparing + if_branch + else_branch + clearing
  end

  def cycle(body)
    '[' + body + ']'
  end

  def scan
    ','
  end

  def print
    '.'
  end
end

if $PROGRAM_NAME == __FILE__
  unless ARGV.empty?
    c = Compiler.new
    File.open(ARGV[0]).each do |line|
      c.parse_command(line)
    end

    File.open(ARGV[0].split('.')[0] + '.bf', 'w+') do |file|
      file.puts c.result
    end
  end
end
