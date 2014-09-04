require 'sinatra'
require 'json'

module StaticViewer
  class Server < Sinatra::Base
    #use Rack::Auth::Basic, "Restricted Area" do |username, password|
    #  username == ENV['AUTH_USENAME'] and password == ENV['AUTH_PASSWORD']
    #end

    get '/' do
      @tree = JSON.dump(tree('public/test'))
      slim :index
    end

    def tree(path)
      data = []
      Dir.foreach(path) do |entry|
        next if (entry == '..' || entry == '.')

        child = {}
        full_path = File.join(path, entry)
        if File.directory?(full_path)
          child[:children] = tree(full_path)
        end
        child[:name] = entry
        data << child
      end
      data
    end
  end
end
