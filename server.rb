require 'sinatra'

module StaticViewer
  class Server < Sinatra::Base
    get '/' do
      'Hello World'
    end
  end
end
