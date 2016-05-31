require 'socket'

class Server
  def initialize
    @server_count = 0
    start_server
  end

  def start_server
    @server_count= @server_count + 1
    tcp_server = TCPServer.new(9292)
    client = tcp_server.accept
    get_request(tcp_server,client)
  end


   def get_request(tcp_server,client)
    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    puts "Got this request:"
    puts request_lines.inspect
    send_response(tcp_server,client)
  end

    def send_response(tcp_server,client)
    puts "Sending response."
    response = "<pre>" + "</pre>" + "<pre>Hello world (#{@server_count})</pre>"
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
      tcp_server.close
    end
  end
