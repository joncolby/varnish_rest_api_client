require "thor"
require "json"
require 'open-uri'
require 'zk'
require_relative "version"

module VarnishRestApiClient

class Client < Thor
  class_option :varnish, :aliases => "V", :desc => "varnish server(s)", :type => :array
  class_option :zkserver, :aliases => "z", :desc => "zookeeper server:port", :default => "autodeploy38-2:2181"
  class_option :zkpath, :aliases => "P", :desc => "zookeeper varnish root path", :default => "/varnish"

  # alternate use invoke
  def initialize(*args)  
    super
    @nodes = Array.new
    @use_zookeeper = use_zookeeper
    if @use_zookeeper  
      @nodes = get_zk_nodes
    else
      @nodes = options[:varnish]
    end   
  end 

  desc "out BACKEND", "set health of this varnish BACKEND to sick."
    def out(backend) 
      @nodes.each do |api|
        p = call_rest(api)
        puts p.call("#{backend}/out")
      end      
    end
    
  desc "in BACKEND", "set health of this varnish BACKEND to auto"
    def in(backend)
      @nodes.each do |api|
        p = call_rest(api)
        puts p.call("#{backend}/in")
      end
    end
    
  desc "show", "show varnish hosts registered with zookeeper"
    def show
      puts @nodes.join("\n")
    end
  
  desc "list PATTERN", "display all varnish backends"
    def list(pattern=nil)      
      backends_found = Array.new      
        @nodes.each do |api|           
          uri = pattern ?  "list/#{pattern}" : "list"      
          p = call_rest(api)
          result = p.call(uri)          
          next if result.empty?          
          if result.first.class != Hash
             puts "error from #{api}: #{result}"
          end
          
          backends_found << result
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
    
    def call_rest(node) 
      return Proc.new do |action| 
        begin          
         buffer = open("http://#{node}/#{action}").read
         result = JSON.parse(buffer)
         result.collect! { |e| e["varnishhost"] = node ; e  } 
        rescue SocketError => e
         abort "problem connecting rest api at #{node}: #{e.message}"
        rescue OpenURI::HTTPError => e
         abort "problem calling rest api at #{node}: #{e.message}"
        end
      end
    end
    
    def call_restb(url,node_name) 
      begin          
       buffer = open(url).read
       result = JSON.parse(buffer)
       result.collect! { |e| e["varnishhost"] = node_name ; e  } 
      rescue SocketError => e
       abort "problem connecting rest api at #{url}: #{e.message}"
      rescue OpenURI::HTTPError => e
       abort "problem calling rest api at #{url}: #{e.message}"
      end
      if block_given?
        yield result
      else
        result
      end
    end
    
   end
    
end

end

# https://gist.github.com/kyletcarlson/7911188
# http://blog.paracode.com/2012/05/17/building-your-tools-with-thor/
# print_table ! ask !
# http://www.rubydoc.info/gems/user_config/0.0.4/frames