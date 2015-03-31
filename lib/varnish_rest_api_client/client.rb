require "thor"
require "json"
require 'open-uri'
require 'zk'
require_relative "version"

module VarnishRestApiClient

class Client < Thor
  class_option :varnish, :aliases => "V", :desc => "varnish server(s)"
  class_option :zkserver, :aliases => "z", :desc => "zookeeper server:port", :default => "192.168.33.16:2181"

  # alternate use invoke
def initialize(*args)  
    super 
    @use_zookeeper = use_zookeeper
    if @use_zookeeper  
      @discovered_zookeepers = get_zk_nodes
    end   
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
      if @use_zookeeper
        @discovered_zookeepers.each do |api| 
          # exception handling
          buffer = open("http://#{api}/list").read
          result = JSON.parse(buffer)
          result << { :varnish_host => "#{api}" } 
        end
      else
        # do one varnish lookup
      end

    end
    
   no_commands do 
     
    def use_zookeeper
       if options[:varnish].nil? || options[:varnish].empty?
         return true
       end
         return false
    end
     
    def get_zk_nodes
      begin
        @zk = ZK.new(options[:zkserver])
      rescue ArgumentError => e
        abort "could not connect to zookeeper server: #{options[:zookeeper]}"
      end
      nodes = @zk.children('/varnish', :watch => false)
      return nodes.collect do |node| 
        data, stat = @zk.get("/varnish/#{node}", :watch => false)
        data.chomp
      end 
    end
   end
    
end

end

# https://gist.github.com/kyletcarlson/7911188
# http://blog.paracode.com/2012/05/17/building-your-tools-with-thor/
# print_table ! ask !
# http://www.rubydoc.info/gems/user_config/0.0.4/frames