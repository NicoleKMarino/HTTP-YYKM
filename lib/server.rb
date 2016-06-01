require 'socket'
require 'pry'
class Server
  def initialize
    @server_count = 0
    @tcp_server = TCPServer.new(9292)
    start_server
  end

  def start_server
    @server_count= @server_count + 1
    while client = @tcp_server.accept
      get_request(@tcp_server,client)
    end
  end


  def get_request(tcp_server,client)
    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    puts "Got this request:"
    puts request_lines.inspect
    send_response(tcp_server,client,request_lines)
  end

  def send_response(tcp_server,client,request_lines)
    ip = Socket.ip_address_list[1].ip_address
    host = Socket.gethostname
    port = tcp_server.addr[1]
    request = request_lines[0].split(" ")
    puts "Sending response."
    if request[1] == "/hello"
      response = "Hello word (#{@server_count})"
    elsif request[1] == "/datetime"
      response = "#{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}"
    elsif request[1] == "/shutdown"
      response = "Total Requests:#{@server_count}"
      response_puts(response, client)
    else
      "<pre>" +
      "Verb: #{request[0]}
      Path: #{request[1]}
      Protocol: #{request[2]}
      Host: #{host} #{ip}
      Port: #{port}
      Origin:#{ip}
      Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" + "</prev"
    end
    response_puts(response,client)
  end


  def response_puts(response,client)
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts output
      puts ["Wrote this response:", headers, output].join("\n")
      puts "\nResponse complete, exiting."
      client = tcp_server.close
    end

  end
