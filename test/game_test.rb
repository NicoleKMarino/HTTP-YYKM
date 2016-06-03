require "minitest/autorun"
require "minitest/pride"
require "./lib/game.rb"

class GameTest < Minitest::Test
  def test_game_generates_random_number
    guessing_game = Game.new
    assert guessing_game.generate_random_number.instance_of?(Fixnum)
  end

  def test_guess_count_works
    guessing_game = Game.new
    guessing_game.play(50)
    guessing_game.play(25)
    assert_equal 2, guessing_game.guess_count
  end

  def test_most_recent_guess_is_stored
    guessing_game = Game.new
    guessing_game.play(50)
    assert_equal 50, guessing_game.most_recent_guess
  end

  def test_most_recent_guess_result_is_stored
    guessing_game = Game.new
    guessing_game.play(50)
    refute guessing_game.most_recent_guess_result.empty?
  end

  def test_game_answer_remains_static_throughout_gameplay
    guessing_game = Game.new
    guessing_game.play(50)
    first_round = guessing_game.random_number
    guessing_game.play(25)
    second_round = guessing_game.random_number
    assert_equal first_round, second_round
  end
end
