require File.dirname(__FILE__) + '/../lib/text_generator'
require 'rubygems'
require 'mocha'

describe TextGenerator do
  before(:each) do
    @tg = TextGenerator.new
  end
  
  it "should split seed text into sentences" do
    @tg.sentences("She said.  He said!").should == ["She said.", "He said!"]
  end

  it "should increment probabilities of adjacent words in sentences" do
    @tg.stub!(:sentences).and_return(["She said.", "He said!"])
    @tg.markov_chain.should_receive(:increment_probability).with("She", "said.")
    @tg.markov_chain.should_receive(:increment_probability).with("He", "said!")
    @tg.seed("She said. He said!")
  end
  
  it "should output random walk of markov chain as generated text" do
    @tg.markov_chain.stub!(:random_walk).and_return(["Start", "at", "the", "beginning."])
    @tg.generate.should == "Start at the beginning."
  end
  
end