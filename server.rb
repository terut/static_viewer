require 'sinatra'

module Pebbles
  class Server < Sinatra::Base
    get '/' do
      'Hello World'
    end
  end
end
