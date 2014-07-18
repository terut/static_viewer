require 'bundler'
Bundler.require(:default)
require File.expand_path('../server.rb', __FILE__)
run Pebbles::Server
