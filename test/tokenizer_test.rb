require 'test/unit'
require_relative '../lib/tokenizer'

class TokenizersTest < Test::Unit::TestCase

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

  def test_shift
    assert_equal(
      { 'type' => 'instruction', 'command' => 'shift', 'args' => [1] },
      Tokenizer.get_instruction_tokenizer('@').call('@ 1'),
      'shift tokenize'
    )
  end

  def test_inc
    assert_equal(
      { 'type' => 'instruction', 'command' => 'increment', 'args' => [1] },
      Tokenizer.get_instruction_tokenizer('inc').call('inc 1'),
      'increment tokenize'
    )
  end

  def test_dec
    assert_equal(
      { 'type' => 'instruction', 'command' => 'decrement', 'args' => [1] },
      Tokenizer.get_instruction_tokenizer('dec').call('dec 1'),
      'decrement tokenize'
    )
  end

  def test_add
    assert_equal(
      { 'type' => 'instruction', 'command' => 'add', 'args' => [20] },
      Tokenizer.get_instruction_tokenizer('add').call('add 20'),
      'add tokenize'
    )
  end

  def test_zero
    assert_equal(
      { 'type' => 'instruction', 'command' => 'zero' },
      Tokenizer.get_instruction_tokenizer('zero').call('zero 20'),
      'zero tokenize'
    )
  end

  def test_copy
    assert_equal(
      { 'type' => 'instruction', 'command' => 'copy', 'args' => [20, 10] },
      Tokenizer.get_instruction_tokenizer('copy').call('copy 20 10'),
      'copy tokenize'
    )
  end

  def test_set
    assert_equal(
      { 'type' => 'instruction', 'command' => 'set', 'args' => [15] },
      Tokenizer.get_instruction_tokenizer('set').call('set 15'),
      'set tokenize'
    )
  end

  def test_mov
    assert_equal(
      { 'type' => 'instruction', 'command' => 'mov', 'args' => [20] },
      Tokenizer.get_instruction_tokenizer('mov').call('mov 20'),
      'mov tokenize'
    )
  end

  def test_print
    assert_equal(
      { 'type' => 'instruction', 'command' => 'print', 'args' => [5] },
      Tokenizer.get_instruction_tokenizer('print').call('print 5'),
      'mov tokenize'
    )
  end

  def test_scan
    assert_equal(
      { 'type' => 'instruction', 'command' => 'scan', 'args' => [8] },
      Tokenizer.get_instruction_tokenizer('scan').call('scan 8'),
      'mov tokenize'
    )
  end

  def test_instruction
    assert_equal(
      { 'type' => 'instruction', 'command' => 'mov', 'args' => [20] },
      Tokenizer.tokenize_instruction('mov 20'),
      'line tokenize'
    )
  end

  def test_ifzero
    assert_equal(
      {
        'type' => 'directive', 'command' => 'ifzero', 'temporary cell' => 1,
        'true_body' =>
        [
          { 'type' => 'instruction', 'command' => 'increment', 'args' => [3] },
        ], 'false_body' =>
        [
          { 'type' => 'instruction', 'command' => 'decrement', 'args' => [3] }
        ]
      },
      Tokenizer.get_directive_tokenizer('ifzero').call(
        ['#ifzero 1', 'inc 3', '#else', 'dec 3', '#end']
      ),
      'ifzero tokenize'
    )
  end
  
  def test_loop
    assert_equal(
      {
        'type' => 'directive', 'command' => 'loop',
        'body' =>
          [
            { 'type' => 'instruction', 'command' => 'increment', 'args' => [3] },
            { 'type' => 'instruction', 'command' => 'shift', 'args' => [3] }
          ]
      },
      Tokenizer.get_directive_tokenizer('loop').call(
        ['#loop', 'inc 3', '@ 3', '#end']
      ),
      'loop tokenize'
    )
  end

  def test_inline
    assert_equal(
      {
        'type' => 'directive', 'command' => 'inline',
        'body' =>
          '+++++++-->>><<,.'
      },
      Tokenizer.get_directive_tokenizer('inline').call(
        ['#inline', '+++++ ++', '-- >>> <<', ', .', '#end']
      ),
      'inline tokenize'
    )
  end

  def test_using
    assert_equal(
      {
        'type' => 'directive', 'command' => 'using', 'shift' => 2,
        'body' =>
          [{ 'type' => 'instruction', 'command' => 'increment', 'args' => [3] }]
      },
      Tokenizer.get_directive_tokenizer('using').call(
        ['#using 2', 'inc 3', '#end']
      ),
      'using tokenize'
    )
  end

  def test_full
    assert_equal(
      [
        { 'type' => 'instruction', 'command' => 'increment', 'args' => [2] },
        { 'type' => 'instruction', 'command' => 'shift', 'args' => [3] },
        { 'type' => 'instruction', 'command' => 'add', 'args' => [2] }
      ],
      Tokenizer.tokenize(['inc 2', '@ 3', 'add 2']),
      'full tokenize'
    )
  end

  # Fake test
  # def test_fail
  # fail('Not implemented')
  # end
end