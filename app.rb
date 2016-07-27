require 'sinatra/base'

module TurboChat
  class App < Sinatra.base
    get '/' do
      erb :"index.html"
    end
  end
end
