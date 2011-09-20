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

  describe "fetch" do
    use_vcr_cassette "ur10777143"
    
    before(:each) do
      @list = ImdbLists.fetch("http://www.imdb.com/user/ur10777143/ratings")
    end
    
    it "should have a name" do
      @list.name.should eq("Demon_Hunter777's Ratings")
    end
    
    it "should have csv link" do
      @list.csv.should eq("http://www.imdb.com/list/export?list_id=ratings&author_id=ur10777143")
    end
    
    it "should have 693 movies" do
      @list.should have(693).movies
    end
  end
end