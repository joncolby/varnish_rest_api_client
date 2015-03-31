require "thor"
require "json"
require 'open-uri'
require 'zk'
require_relative "version"

module VarnishRestApiClient
  
class Client < Thor
  class_option :zkserver, :aliases => "zs", :desc => "zookeeper server or ip"
  class_option :zkport, :default => 2181, :aliases => "zp", :desc => "zookeeper port"
  class_option :varnish, :required => true,  :aliases => "V", :desc => "varnish server(s)"
  
  # alternate use invoke
  def initialize(*args)
    super
    get_zk_nodes
  end 
     
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
      #puts result
    end
    
   no_commands { 
    def get_zk_nodes
      @zk = ZK.new("autodeploy38-2:2181")
      nodes = @zk.children('/varnish', watch: false)
      nodes.each do |node| 
        data, stat = @zk.get("/varnish/#{node}", watch: false)
        puts data
      end 
    end
   }
  
  
end

end

# https://gist.github.com/kyletcarlson/7911188
# http://blog.paracode.com/2012/05/17/building-your-tools-with-thor/
# print_table ! ask !
# http://www.rubydoc.info/gems/user_config/0.0.4/frames