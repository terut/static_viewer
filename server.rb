require 'sinatra'
require 'json'
require 'git'
require 'pp'

module StaticViewer
  class Server < Sinatra::Base
    #use Rack::Auth::Basic, "Restricted Area" do |username, password|
    #  username == ENV['AUTH_USENAME'] and password == ENV['AUTH_PASSWORD']
    #end
    use Rack::Access, {
      '/' => ENV['ALLOW_IPS'].split(',')
    } if ENV['ALLOW_IPS']

    get '/' do
      @repos = Dir.chdir("repos") { Dir.glob("*") }

      slim :index
    end

    get '/repos/:name' do
      working_dir = "repos/#{params[:name]}"
      @g = Git.open(working_dir, log: nil)
      tree = { name: params[:name], children: tree(working_dir) }
      @tree = JSON.dump(tree)

      slim :repos
    end

    post '/repos' do
      url = params[:url]
      name = params[:name]
      g = Git.clone(url, name, path: 'repos/')

      redirect '/'
    end

    post '/repos/:name/pull' do
      working_dir = "repos/#{params[:name]}"
      g = Git.open(working_dir, log: nil)
      g.checkout
      g.fetch('origin', { p: true })
      g.merge("origin/#{g.current_branch}")

      redirect "/repos/#{params[:name]}"
    end

    post '/repos/:name/checkout' do
      working_dir = "repos/#{params[:name]}"
      g = Git.open(working_dir, log: nil)
      g.checkout

      if params[:branch] != "master" && !params[:branch].start_with?("HEAD") && g.is_local_branch?(params[:branch])
        pp "hoge"
        g.branch(params[:branch]).delete
      end
      g.checkout(params[:branch])

      redirect "/repos/#{params[:name]}"
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
