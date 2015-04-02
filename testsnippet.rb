class Testsnippet
  
  def process(nodes)
    puts "open url http://whatever"

    lambda { |n| nodes.each { |node | puts "#{node}=#{n}=" } }


  end
  
end

#nodes = [{"a" => 1}, {"b" => 2}, {"c" => 3}]
nodes = ["servera","serverb","serverc"]
  
  
t = Testsnippet.new

p = t.process(nodes)

p.call("hiii")
