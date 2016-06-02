require_relative "responder"
require_relative "game"

class Parser

  attr_accessor :gameplay

  def initialize(server)
    @gameplay = Game.new
    @request_total = 0
    loop {receive_request(server)}
  end

  def receive_request(server)
    @request_total += 1
    client = server.accept
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    Responder.new(server, client, request_lines, @request_total, @gameplay)
  end

end
