module Tokenizer
  @instruction_tokenizers = {
    '@' => lambda do |line|
      {
        'type' => 'instruction',
        'command' => 'shift',
        'args' => [line.split[1].to_i]
      }
    end,
    'inc' => lambda do |line|
      {
        'type' => 'instruction', 
        'command' => 'increment', 
        'args' => [line.split[1].to_i]
      }
    end,
    'dec' => lambda do |line|
      {
        'type' => 'instruction', 
        'command' => 'decrement', 
        'args' => [line.split[1].to_i]
      }
    end,
    'add' => lambda do |line|
      {
        'type' => 'instruction',
        'command' => 'add',
        'args' => [line.split[1].to_i]
      }
    end,
    'zero' => lambda do |line|
      {
        'type' => 'instruction',
        'command' => 'zero'
      }
    end,
    'copy' => lambda do |line|
      {
        'type' => 'instruction',
        'command' => 'copy',
        'args' => [line.split[1].to_i, line.split[2].to_i]
      }
    end,
    'set' => lambda do |line|
      {
        'type' => 'instruction',
        'command' => 'set',
        'args' => [line.split[1].to_i]
      }
    end,
    'mov' => lambda do |line|
      {
        'type' => 'instruction',
        'command' => 'mov',
        'args' => [line.split[1].to_i]
      }
    end,
    'print' => lambda do |line|
      {
        'type' => 'instruction',
        'command' => 'print',
        'args' => [line.split[1].to_i]
      }
    end,
    'scan' => lambda do |line|
      {
        'type' => 'instruction',
        'command' => 'scan',
        'args' => [line.split[1].to_i]
      }
    end
  }
  
  @directive_marker = '#'

  @directive_tokenizers = {
    'ifzero' => lambda do |lines|
      i = 0
      counter = 0
      body = lines.slice(1, lines.length - 2)
      while i < body.length
        line = body[i]
        i += 1
        next if line.nil?
        next unless directive?(line)
        cmd = line.delete(@directive_marker).split[0]
        if cmd == 'ifzero'
          counter += 1
        elsif cmd == 'else'
          counter > 0 ? counter -= 1 : break
        end
      end
      {
        'type' => 'directive',
        'command' => 'ifzero',
        'temporary cell' => lines[0].split[1].to_i,
        'true_body' => tokenize(body.slice(0, i - 1)),
        'false_body' => tokenize(body.slice(i, body.length))
      }
    end,
    'loop' => lambda do |lines|
      {
        'type' => 'directive',
        'command' => 'loop',
        'body' => tokenize(lines.slice(1, lines.length - 2))
      }
    end,
    'inline' => lambda do |lines|
      body = ''
      lines.slice(1, lines.length - 2)
           .map { |line| line.strip.delete(' ') }
           .each { |line| body << line }
      {
        'type' => 'directive',
        'command' => 'inline',
        'body' => body
      }
    end,
    'using' => lambda do |lines|
      {
        'type' => 'directive',
        'command' => 'using',
        'shift' => lines[0].split[1].to_i,
        'body' => tokenize(lines.slice(1, lines.length - 2))
      }
    end
  }

  def self.get_instruction_tokenizer(instruction)
    raise 'unknown instruction: ' << instruction if @instruction_tokenizers[instruction].nil?
    @instruction_tokenizers[instruction]
  end

  def self.get_directive_tokenizer(directive)
    raise 'unknown directive: ' << directive if @directive_tokenizers[directive].nil?
    @directive_tokenizers[directive]
  end

  def self.tokenize(lines)
    raise 'lines must be Array, but received ' << lines.class.to_s unless lines.is_a?(Array)
    lines.each { |line| raise 'every line must be a sting' unless line.is_a?(String) }
    res = []
    i = 0
    while i <= lines.length
      line = lines[i]
      unless line.nil?
        if directive?(line)
          j = get_directive_end(i, lines)

          buf = lines.slice(i, j - i)
          i = j - 1
          res << tokenize_directive(buf)
        else
          res << tokenize_instruction(line)
        end
      end
      i += 1
    end
    res
  end

  def self.tokenize_instruction(line)
    get_instruction_tokenizer(line.split[0]).call(line)
  end

  def self.tokenize_directive(lines)
    get_directive_tokenizer(lines[0].split[0].delete(@directive_marker)).call(lines)
  end

  def self.directive?(line)
    line.reverse.strip.reverse[0] == @directive_marker
  end

  private

  def self.get_directive_end(i, lines)
    counter = 0
    j = i + 1

    while j < lines.length
      line1 = lines[j]
      j += 1
      next if line1.nil?
      next unless directive?(line1)
      cmd = line1.delete(@directive_marker).split[0]
      next if cmd == 'else'
      if cmd == 'end' then
        if counter > 0
          counter -= 1
        else
          break
        end
      else
        counter += 1
      end
    end
    j
  end
end