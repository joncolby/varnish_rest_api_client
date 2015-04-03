require "thor"
require "json"
require 'open-uri'
require 'zk'
require_relative "version"

module VarnishRestApiClient

class Client < Thor
  class_option :varnish, :aliases => "V", :desc => "varnish server(s)"
  class_option :zkserver, :aliases => "z", :desc => "zookeeper server:port", :default => "autodeploy38-2:2181"
  class_option :zkpath, :aliases => "P", :desc => "zookeeper varnish root path", :default => "/varnish"

  # alternate use invoke
  def initialize(*args)  
    super
    @nodes = Array.new
    @use_zookeeper = use_zookeeper
    if @use_zookeeper  
      @nodes = get_zk_nodes

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
    
  desc "show", "show varnish hosts registered with zookeeper"
    def show
      puts @nodes.join("\n")
    end
  
  desc "list PATTERN", "display all varnish backends"
    def list(pattern=nil)
      
      backends_found = Array.new      
      unless @use_zookeeper
        @nodes << options[:varnish]
      end

        @nodes.each do |api|        
          if pattern
            uri = "http://#{api}/list/#{pattern}"
          else
            uri = "http://#{api}/list" 
          end 
           
          # TODO implement call_rest here         
          begin          
            buffer = open(uri).read
          rescue SocketError => e
            abort "problem connecting rest api at #{uri}: #{e.message}"
          rescue OpenURI::HTTPError => e
            abort "problem calling rest api at #{uri}: #{e.message}"
          end
          result = JSON.parse(buffer)

          next if result.empty?
          
          if result.first.class != Hash
             puts "error from #{api}: #{result}"
          end
          
          backends_found << result.collect { |e| e["varnishhost"] = api ; e  }  
        end
           puts backends_found.empty? ? "no backends found for pattern #{pattern}" : backends_found
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
      rescue ArgumentError, RuntimeError => e
        $stderr.puts "\n\tcould not connect to zookeeper server: #{options[:zkserver]}\n\n"
        help
        exit(1) 
      end
      
      begin
      nodes = @zk.children(options[:zkpath], :watch => false)
      rescue ZK::Exceptions::NoNode => e
        abort "no nodes found in path #{options[:zkpath]} on zookeeper server #{options[:zkserver]}"
      end
      return nodes.collect do |node| 
        data, stat = @zk.get("/varnish/#{node}", :watch => false)
        data.chomp
      end 
    end
    
    def call_rest(url) 
      begin          
       buffer = open(url).read
      rescue SocketError => e
       abort "problem connecting rest api at #{url}: #{e.message}"
      rescue OpenURI::HTTPError => e
       abort "problem calling rest api at #{url}: #{e.message}"
      end
      if block_given?
        yield buffer
      else
        buffer
      end
    end
    
   end
    
end

end

# https://gist.github.com/kyletcarlson/7911188
# http://blog.paracode.com/2012/05/17/building-your-tools-with-thor/
# print_table ! ask !
# http://www.rubydoc.info/gems/user_config/0.0.4/frames