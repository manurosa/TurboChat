require 'sinatra/base'

module TurboChat
  class App < Sinatra::Base
    get '/' do
      erb :"index.html"
    end
  end
end
