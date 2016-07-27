require 'faye/websocket'

module TurboChat
  class ChatBackend
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSWocket.websocket? env
        # WebSockets logic goes here
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)

        ws.on :open do |_event|
          p [:open, ws.object_id]
          @clients << ws
        end

        ws.on :message do |event|
          p[:message, event.data]
          @clients.each { |client| client.send(event.data) }
        end

        ws.on :close do |event|
          p[:close, ws.object_id, event.code, event.reason]
          @client.delete(ws)
          ws = nil
        end
      # Returns async Rack response
      else
        @app.call(env)
      end
    end
  end
end
