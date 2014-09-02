require 'sinatra'

module StaticViewer
  class Server < Sinatra::Base
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == ENV['AUTH_USENAME'] and password == ENV['AUTH_PASSWORD']
    end

    get '/' do
      'Hello World'
    end
  end
end
