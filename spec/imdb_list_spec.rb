require "spec_helper"

describe ImdbLists do
  describe "arguments" do
    it "should raise an error if url is invalid" do
      lambda { ImdbLists.fetch("random") }.should raise_error(ArgumentError, "Invalid url")
    end
    
    it "should NOT raise an error if url is valid" do
      lambda { ImdbLists.fetch("http://www.imdb.com/user/ur10777143/ratings") }.should_not raise_error
    end
  end
end