require 'socket'
require 'pry'

class Server
  def initialize
    @request_total = 0
    @tcp_server = TCPServer.new("localhost", 9292)
    # @continue = true
    loop {request}
  end

  def request
    @request_total += 1
    client = @tcp_server.accept
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    send_response(client, request_lines)
  end

  def send_response(client, request_lines)
    request = request_lines[0].split(" ")
    if request[1] == "/hello"
      response = "Hello word (#{@server_count})".concat("\n\n\n\n#{response_details(request)}")
    elsif request[1] == "/datetime"
      response = "#{Time.now.strftime('%a,%e %b %Y %H:%M:%S')}".concat("\n\n\n\n#{response_details(request)}")
    elsif request[1].include?("/word_search") == true
      word = request[1].partition('=').last
      response = word_search(word).concat("\n\n\n\n#{response_details(request)}")
    elsif request[1] == "/shutdown"
      response = "Total Requests:#{@server_count}".concat("\n\n\n\n#{response_details(request)}")
    else
      response = response_details(request)
    end
    client.puts html_headers(response)
    client.puts html_body_message(response)
    client.close
  end

  def word_search(word)
    lines = File.readlines('/usr/share/dict/words').grep(/#{word}/)
    if lines.empty? == true
      return "The word is unknown"
    else
      return "That word is known"
    end
  end

  def html_body_message(message)
    output = "<html><head></head><body>#{message}</body></html>"
  end

  def html_headers(message)
    headers = ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{html_body_message(message).length}\r\n\r\n"].join("\r\n")
  end

  def response_details(request)
    ip = Socket.ip_address_list[1].ip_address
    host = Socket.gethostname
    port = @tcp_server.addr[1]
    "<pre>" +
    "Verb: #{request[0]}
    Path: #{request[1]}
    Protocol: #{request[2]}
    Host: #{host} #{ip}
    Port: #{port}
    Origin:#{ip}
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" + "</prev"
  end


end

Server.new
