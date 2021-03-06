require File.dirname(__FILE__) + '/markov_chain'

class TextGenerator
  attr_reader :markov_chain
  
  def initialize
    @markov_chain = MarkovChain.new
  end
  
  def seed(text)
  end
  
  def sentences(text)
  end
  
  def generate(start)
    @markov_chain.random_walk(start).join(" ")
  end
  
end