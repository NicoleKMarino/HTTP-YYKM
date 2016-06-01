require 'socket'
require 'pry'
require_relative "parser"

class Server
  def initialize
    server = TCPServer.new("localhost", 9292)
    Parser.new(server)
  end
end

Server.new
