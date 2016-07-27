require 'socket'
class Server
  def initialize(ip, port)
    @server = TCPServer.open(ip, port)
    @connections = {}
    @rooms = {}
    @clients = {}
    @connections[:server] = @server
    @connections[:rooms] = @rooms
    @connections[:clients] = @clients
    run
  end

  def run
    loop do
      # for each user connected and accepted by the server,
      # it will create a new thread and will pass
      # the connected client as an instance to the block
      Thread.start(@server.accept) do |client|
        nick_name = client.gets.chomp.to_sym
        @connections[:clients].each do |other_name, other_client|
          if nick_name == other_name || client == other_client
            client.puts 'This username is already taken'
            Thread.kill self
          end
        end
        puts "#{nick_name} #{client}"
        @connections[:clients][nick_name] = client
        client.puts 'Connection established. Thanks for joining!'

        listen_user_messages(nick_name, client)
      end
    end.join
  end

  def listen_user_messages(username, client)
    loop do
      # get client messages
      msg = client.gets.chomp
      # send a broadcast message for all connected users but themselves
      @connections[:clients].each do |other_name, other_client|
        other_client.puts "#{username}: #{msg}" unless other_name == username
      end
    end
  end
end

Server.new('localhost', 3000) # (ip, port) in each machine "localhost" = 127.0.0.1
