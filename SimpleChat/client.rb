require 'socket'
class Client
  def initialize(server)
    @server = server
    @request = nil
    @response = nil
    listen
    send
    @request.join
    @response.join
  end

  def listen
    @response = Thread.new do
      loop do
        msg = @server.gets.chomp
        puts msg.to_s
      end
    end
  end

  def send
    puts 'Enter the username:'
    @request = Thread.new do
      loop do
        msg = $stdin.gets.chomp
        @server.puts(msg)
      end
    end
  end
end

server = TCPSocket.open('localhost', 3000)
Client.new(server)
