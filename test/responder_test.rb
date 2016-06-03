require "minitest/autorun"
require "minitest/pride"
require "./lib/responder"

class ResponderTest < Minitest::Test
  def test_request_path_hello
    response = Faraday.get("http://localhost:9292/hello")
    assert response.body.include? "Hello, World!"
  end

  def test_request_path_datetime
    response = Faraday.get("http://localhost:9292/datetime")
    assert response.body.include? "2016"
  end

  def test_request_path_shutdown
    skip
    response = Faraday.get("http://localhost:9292/shutdown")
    assert response.body.include? "Total Requests:"
  end

  def test_request_path_word_search
    response = Faraday.get("http://localhost:9292/word_search")
    assert response.body.include? "word"
  end

  def test_request_path_word_search_true_negative
    response = Faraday.get("http://localhost:9292/word_search=supercalifragilisticexpialidocious")
    assert response.body.include? " is not a known word"
  end

  def test_request_path_word_search_true_positive
    response = Faraday.get("http://localhost:9292/word_search=tennis")
    assert response.body.include? " is a known word"
  end

  def test_request_path_start_game_is_functional
    response = Faraday.get("http://localhost:9292/start_game")
    assert response.body
    assert_equal 200, response.status
  end

  def test_request_path_game_is_functional
    response = Faraday.get("http://localhost:9292/game")
    assert response.body
    assert_equal 200, response.status
  end

  def test_404_response_exists
    response = Faraday.get("http://localhost:9292/nothing_here")
    assert response.body.include? "404"
    assert_equal 404, response.status
  end

  def test_force_error_operates_correctly
    response = Faraday.get("http://localhost:9292/force_error")
    assert response.body.include? "500"
    assert_equal 500, response.status
    binding.pry
  end
end
