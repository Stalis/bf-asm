require_relative 'tokenizer'
module Translator
  @instruction_translators = {
    'increment' => lambda do |token|
      res = ''
      token['args'][0].times { res << '+' }
      res
    end,
    'decrement' => lambda do |token|
      res = ''
      token['args'][0].times { res << '-' }
      res
    end,
    'shift' => lambda do |token|
      res = ''
      token['args'][0].abs.times {
        res << (token['args'][0] > 0 ? '>' : '<')
      }
      res
    end,
    'zero' => lambda do |token|
      '[-]'
    end,
    'add' => lambda do |token|
      translate(
        Tokenizer.tokenize(
          [
            '#loop',
            'dec 1',
            '@ ' << token['args'][0].to_s,
            'inc 1',
            '@ ' << (-token['args'][0]).to_s,
            '#endloop'
          ]
        )
      )
    end,
    'mov' => lambda do |token|
      translate(
        Tokenizer.tokenize(
          [
            '@ ' << token['args'][0].to_s,
            'zero', '@ ' << (-token['args'][0]).to_s,
            'add ' << token['args'][0].to_s
          ]
        )
      )
    end,
    'copy' => lambda do |token|
      target = token['args'][0]
      temp = token['args'][1]
      translate(
        Tokenizer.tokenize(
          [
            '@ ' << target.to_s,
            'zero',
            '@ ' << temp.to_s,
            'zero',
            '@ ' << (-(target + temp)).to_s,
            '#loop',
            'dec 1',
            '@ ' << target.to_s,
            'inc 1',
            '@ ' << temp.to_s,
            'inc 1',
            '@ ' << (-(target + temp)).to_s,
            '#end',
            '@ ' << (target + temp).to_s,
            'mov ' << (-(target + temp)).to_s
          ]
        )
      )
    end,
    'set' => lambda do |token|
      translate(
        Tokenizer.tokenize(
          [
            'zero',
            'inc ' << token['args'][0].to_s
          ]
        )
      )
    end,
    'print' => lambda do |token|
      arg = token['args'][0]
      res = '.'
      if arg > 1
        (arg - 1).times { res << '>.' }
      end
      res
    end,
    'scan' => lambda do |token|
      arg = token['args'][0]
      res = ','
      (arg - 1).times { res << '>,' } if arg > 1
      res
    end
  }
  @directive_translators = {
    'ifzero' => lambda do |token|
      temp = token['temporary cell']
      true_body = translate(token['true_body'])
      false_body = translate(token['false_body'])
      translate(
        Tokenizer.tokenize(
          [
            '@ ' << temp.to_s,
            'zero',
            'inc 1',
            '@ ' << (-temp).to_s,
            '#loop',
            '  #inline',
            '    ' << true_body,
            '  #end',
            '  @ ' << temp.to_s,
            '  zero',
            '  @ ' << (-temp).to_s,
            '  zero',
            '#end',
            '@ ' << temp.to_s,
            '#loop',
            '  @ ' << (-temp).to_s,
            '  #inline',
            '     ' << false_body,
            '  #end',
            '  @ ' << temp.to_s,
            '  zero',
            '#end',
            '@ ' << (-temp).to_s
          ]
        )
      )
    end,
    'loop' => lambda do |token|
      '[' << translate(token['body']) << ']'
    end,
    'using' => lambda do |token|
      buf = []
      buf << Tokenizer.tokenize_instruction('@ ' << token['shift'].to_s)
      buf += token['body']
      buf << Tokenizer.tokenize_instruction('@ ' << (-token['shift']).to_s)
      translate(buf)
    end,
    'inline' => lambda do |token|
      token['body']
    end
  }

  def self.translate(tokens)
    res = ''
    tokens.each { |token| res << translate_token(token) }
    res
  end

  def self.translate_token(token)
    translator = nil
    if token['type'] == 'instruction'
      translator = get_instruction_translator(token['command'])
    elsif token['type'] == 'directive'
      translator = get_directive_translator(token['command'])
    end
    translator.call(token)
  end

  def self.get_instruction_translator(command)
    @instruction_translators[command]
  end

  def self.get_directive_translator(command)
    @directive_translators[command]
  end
end
