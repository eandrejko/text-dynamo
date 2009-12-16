require File.dirname(__FILE__) + '/../lib/markov_chain'

describe MarkovChain do
  before(:each) do
    @mc = MarkovChain.new
  end
  
  it "should create graph nodes with increment_probability" do
    @mc.increment_probability("start","end")
    @mc.graph.should satisfy { |g|  g.contains?("a")}
    @mc.graph.should satisfy { |g|  g.contains?("b")}
    @mc.graph.edge_weight("start","end").should == 1
  end
  
  it "should increment graph edge weight with increment_probability" do
    @mc.graph.add_node("start")
    @mc.graph.add_node("end")
    @mc.graph.connect("start", "end", 3)
    @mc.increment_probability("start","end")
    @mc.graph.edge_weight("start","end").should == 4
  end
  
  it "should walk directed graph from start to end with random_walk" do
    build_graph
    walk = @mc.random_walk("start")
    walk.length.should == 3
    walk.first.should == "start"
    walk.last.should == "end"
    walk[1].should satisfy { |x|  %w(a b).include?(x)}
  end

  it "should use specified start node" do
    build_graph
    walk = @mc.random_walk("start")
    walk.first.should == "start"
  end
  
  it "should choose node with 0 out-degree as end node" do
    build_graph
    walk = @mc.random_walk
    @mc.graph.out_degree_of(walk.last).should == 0
  end
  
  it "should choose nodes in random_walk randomly by weight" do
    build_graph(:b => 3, :a => 0)
    walk = @mc.random_walk("start")
    walk.should == ["start", "b", "end"]
  end
  
  it "should choose nodes in random_walk randomly by weight" do
    build_graph(:a => 3, :b => 0)
    walk = @mc.random_walk("start")
    walk.should == ["start", "a", "end"]
  end
  
  # this spec only passes with probablity 1 - 1/2**19
  it "should choose nodes in random_walk randomly by weight" do
    build_graph(:b => 1, :a => 1)
    walks = (1..20).map{|i| @mc.random_walk("start")}
    walks.map{|x| x[1]}.uniq.sort.should== ["a", "b"]
  end
  
  def build_graph(weights = {})
    #        a
    #       / \
    # start     end
    #       \ / 
    #        b
    @mc.graph.add_node("start")
    @mc.graph.add_node("end")
    @mc.graph.add_node("a")
    @mc.graph.add_node("b")
    @mc.graph.connect("start","a", weights[:a] || 1)
    @mc.graph.connect("start","b", weights[:b] || 1)
    @mc.graph.connect("a","end")
    @mc.graph.connect("b","end")
  end
  
end