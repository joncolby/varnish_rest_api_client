require "thor"
require "json"
require 'open-uri'
require_relative "version"

module VarnishRestApiClient
  
class Client < Thor
  class_option :zk_server, :default => "autodeploy38-2"
  class_option :varnish, :required => true
      
  desc "out BACKEND", "set health of this varnish BACKEND to sick."
    def out() 
      puts "out "      
    end
    
  desc "in BACKEND", "set health of this varnish BACKEND to auto"
    def in()
      puts "in "
    end
    
  desc "list", "display all varnish backends"
    def list
      puts "connecting to #{options[:varnish]} v #{VERSION}"
      buffer = open("http://#{options[:varnish]}/list").read
      result = JSON.parse(buffer)
      puts result
    end
  
  
end

end

# https://gist.github.com/kyletcarlson/7911188
# http://blog.paracode.com/2012/05/17/building-your-tools-with-thor/
# print_table ! ask !
# http://www.rubydoc.info/gems/user_config/0.0.4/frames