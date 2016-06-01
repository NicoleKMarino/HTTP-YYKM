require "pry"
require "socket"

class Parser

  def initialize(server)
    @request_total = 0
    loop {receive_request(server)}
  end

  def receive_request(server)
    client = server.accept
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    send_response(server, client, request_lines)
  end

  def send_response(server, client, request_lines)
    request = request_lines[0].split(" ")
    response = check_request_path(server, client, request)
    client.puts html_headers(response)
    client.puts html_body_message(response)
    client.close
  end

  def word_search(word)
    lines = File.readlines('/usr/share/dict/words').grep(/#{word}/)
    if lines.empty?
      return "WORD is not a known word"
    else
      return "WORD is a known word"
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

  def check_request_path(server, client, request)
    @request_total += 1
    if request[1] == "/hello"
      response = "Hello, World! (#{@request_total})"
    elsif request[1] == "/datetime"
      response = "#{Time.now.strftime('%a,%e %b %Y %H:%M:%S')}"
    elsif request[1].include?("/word_search") == true
      word = request[1].partition('=').last
      response = word_search(word)
    elsif request[1] == "/shutdown"
      shutdown(server, client, request)
    else
      response = ""
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
    client.close
    server.close
  end

end
