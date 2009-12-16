require File.dirname(__FILE__) + '/weighted_directed_graph'

class MarkovChain
  attr_accessor :graph
  
  def initialize
    @graph = WeightedDirectedGraph.new
  end
  
  def increment_probability(a,b)
  end

  def random_walk(start)
  end

end