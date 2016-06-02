require "minitest/autorun"
require "minitest/pride"
require "./lib/word_search.rb"

class WordSearchTest < Minitest::Test

  def test_word_search_will_accept_string_input
    search = WordSearch.new
    assert search.word_search("word")
  end

  def test_word_search_responds_to_real_words_correctly
    search = WordSearch.new
    assert_equal "dogma is a known word", search.word_search("dogma")
    assert_equal "insomnia is a known word", search.word_search("insomnia")
  end

  def test_word_search_responds_to_false_words_correctly
    search = WordSearch.new
    assert_equal "superbad is not a known word", search.word_search("superbad")
    assert_equal "supercalifragilisticexpialidocious is not a known word", search.word_search("supercalifragilisticexpialidocious")
  end

end
