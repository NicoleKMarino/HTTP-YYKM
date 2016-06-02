require "minitest/autorun"
require "minitest/pride"
require "faraday"
require "pry"

class ServerTest < Minitest::Test
  def test_response_exists
    response = Faraday.get("http://localhost:9292")
    assert response.body
  end

end
