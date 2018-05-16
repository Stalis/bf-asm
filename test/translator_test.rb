require 'test/unit'
require_relative '../lib/translator'
require_relative '../lib/tokenizer'

class TranslatorTest < Test::Unit::TestCase
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_increment
    assert_equal(
      '+++',
      Translator.translate_token(Tokenizer.tokenize_instruction('inc 3')),
      'increment translate'
    )
  end

  def test_decrement
    assert_equal(
      '---',
      Translator.translate_token(Tokenizer.tokenize_instruction('dec 3')),
      'decrement translate'
    )
  end

  def test_shift
    assert_equal(
      '>>>>',
      Translator.translate_token(Tokenizer.tokenize_instruction('@ 4')),
      'shift right translate'
    )
    assert_equal(
      '<<',
      Translator.translate_token(Tokenizer.tokenize_instruction('@ -2')),
      'shift left translate'
    )
  end

  def test_zero
    assert_equal(
      '[-]',
      Translator.translate_token(Tokenizer.tokenize_instruction('zero')),
      'zero translate'
    )
  end

  def test_add
    assert_equal(
      '[->>>+<<<]',
      Translator.translate_token(Tokenizer.tokenize_instruction('add 3')),
      'add translate'
    )
  end

  def test_mov
    assert_equal(
      '>>>[-]<<<[->>>+<<<]',
      Translator.translate_token(Tokenizer.tokenize_instruction('mov 3')),
      'add translate'
    )
  end

  def test_copy
    assert_equal(
      '>>[-]>>>[-]<<<<<[->>+>>>+<<<<<]>>>>><<<<<[-]>>>>>[-<<<<<+>>>>>]',
      Translator.translate_token(Tokenizer.tokenize_instruction('copy 2 3')),
      'add translate'
    )
  end

  def test_set
    assert_equal(
      '[-]+++++',
      Translator.translate_token(Tokenizer.tokenize_instruction('set 5')),
      'add translate'
    )
  end

  def test_print
    assert_equal(
      '.>.>.>.>.',
      Translator.translate_token(Tokenizer.tokenize_instruction('print 5')),
      'add translate'
    )
  end

  def test_scan
    assert_equal(
      ',>,>,',
      Translator.translate_token(Tokenizer.tokenize_instruction('scan 3')),
      'add translate'
    )
  end

  def test_ifzero
    assert_equal(
      '>>[-]+<<[+++>>[-]<<[-]]>>[<<--->>[-]]<<',
      Translator.translate_token(Tokenizer.tokenize_directive(
                                   ['#ifzero 2', '  inc 3', '#else', '  dec 3', '#end']
      )),
      'add translate'
    )
  end

  def test_loop
    assert_equal(
      '[++]',
      Translator.translate_token(Tokenizer.tokenize_directive(
                                   ['#loop', '  inc 2', '#end']
      )),
      'add translate'
    )
  end

  def test_inline
    assert_equal(
      '++++--<',
      Translator.translate_token(Tokenizer.tokenize_directive(
                                   ['#inline', '  ++++', '  -- <', '#end']
      )),
      'add translate'
    )
  end

  def test_using
    assert_equal(
      '>>++<<',
      Translator.translate_token(Tokenizer.tokenize_directive(
                                   ['#using 2', '  inc 2', '#end']
      )),
      'add translate'
    )
  end
end
