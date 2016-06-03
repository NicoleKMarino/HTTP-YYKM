require "minitest/autorun"
require "minitest/pride"
require "faraday"

class ServerTest < Minitest::Test
  def test_response_exists
    response = Faraday.get("http://localhost:9292")
    assert response.body
    assert_equal 200, response.status
  end

end
