require "minitest/autorun"
require "minitest/pride"
require "./lib/parser"

class ParserTest < Minitest::Test
  def test_response_body_includes_request_details
    response = Faraday.get("http://localhost:9292")
    assert response.body.include? "Verb:"
    assert response.body.include? "Path:"
    assert response.body.include? "Protocol:"
    assert response.body.include? "Host:"
    assert response.body.include? "Port:"
    assert response.body.include? "Origin:"
    assert response.body.include? "Accept:"
    assert_equal 200, response.status
  end
end
