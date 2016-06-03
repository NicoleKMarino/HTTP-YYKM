require "socket"
require_relative "word_search"
require_relative "game"
require_relative "html_formatting"
require_relative "game_handler"

class Responder

  include HTMLFormatting
  include GameHandler

  def initialize(server, client, request_lines, request_total, active_game)
    @request_lines = request_lines
    @gameplay = active_game
    @request_total = request_total
    @status = "200 ok"
    send_response(server, client, request_lines, @gameplay)
  end

  def send_response(server, client, request_lines, active_game)
    request = request_lines[0].split(" ")
    response = check_request_path(server, client, request, @gameplay)
    client.puts html_headers(response)
    client.puts html_body_message(response)
    client.close
  end

  def check_request_path(server, client, request, active_game)
    @request_total += 1
    if request[1] == "/hello"
      response = "Hello, World! (#{@request_total})"
    elsif request[1] == "/datetime"
      response = "#{Time.now.strftime('%a,%e %b %Y %H:%M:%S')}"
    elsif request[1].include?("/word_search")
      word = request[1].partition('=').last
      response = WordSearch.new.word_search(word)
    elsif request[1].include?("game")
      response = game_response_paths(request, client)
    elsif request[1] == "/shutdown"
      shutdown(server, client, request)
    elsif request[1] == "/"
      response = ""
    elsif request[1] == "/force_error"
      @status = "500 Internal Server Error"
      response = "500 - Internal System Error"
    else
      @status = "404 not found"
      response = "404 not found"
    end
    return response + print_request_details(server, request)
  end

  def print_request_details(server, request)
    ip = Socket.ip_address_list[1].ip_address
    host = Socket.gethostname
    port = server.addr[1]
    "<pre>" +
    "Verb: #{request[0]}
    Path: #{request[1]}
    Protocol: #{request[2]}
    Host: #{host} #{ip}
    Port: #{port}
    Origin:#{ip}
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" + "</prev"
  end

  def shutdown(server, client, request)
    response = "Total Requests:#{@request_total}"
    client.puts html_headers(response + print_request_details(server, request))
    client.puts html_body_message(response + print_request_details(server, request))
    server.close
  end

end
