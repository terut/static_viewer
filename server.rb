require 'sinatra'
require 'json'
require 'git'
require 'pp'

module StaticViewer
  class Server < Sinatra::Base
    #use Rack::Auth::Basic, "Restricted Area" do |username, password|
    #  username == ENV['AUTH_USENAME'] and password == ENV['AUTH_PASSWORD']
    #end

    get '/' do
      @repos = Dir.chdir("repos") { Dir.glob("*") }

      slim :index
    end

    get '/repos/:name' do
      working_dir = "repos/#{params[:name]}"
      g = Git.open(working_dir, log: nil)
      puts g.branches.remote.collect { |branch| branch.name } 
      tree = { name: params[:name], children: tree(working_dir) }
      @tree = JSON.dump(tree)

      slim :repos
    end

    post '/repos/:name/pulls' do
    end

    get '/views/*' do
      send_file(params[:splat].first)
    end

    private
    def tree(path)
      data = []
      Dir.foreach(path) do |entry|
        next if entry.start_with?('.')

        child = {}
        full_path = File.join(path, entry)
        if File.directory?(full_path)
          child[:children] = tree(full_path)
        end

        child[:name] = entry
        child[:full] = full_path
        data << child
      end
      data
    end
  end
end
