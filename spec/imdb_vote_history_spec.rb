describe ImdbVoteHistory do
  before(:all) do
    @url = "http://www.imdb.com/mymovies/list?l=32558051"
    @count = 937
  end
  
  context "the find_by_url method if success" do
    before(:each) do
      stub_request(:any, @url).to_return(:body => File.new("spec/fixtures/32558051.html"), :status => 200)
    end
    
    it "should return a list of movies" do
      ImdbVoteHistory.find_by_url(@url).should have(@count).movies
    end
    
    it "should be able to cache" do
      object = Container::Movie.new(:imdb_link => "http://www.imdb.com/title/tt0460649/")
      Container::Movie.should_receive(:new).exactly(@count).times.and_return(object)
      imdb = ImdbVoteHistory.find_by_url(@url)
      10.times { imdb.movies }
    end
    
    it "should have a user method" do
      ImdbVoteHistory.find_by_url(@url).user.should eq("eddyproca")
    end
    
    it "should have a id method" do
      ImdbVoteHistory.find_by_url(@url).id.should eq(32558051)
    end
    
    it "should contain a list of movies"
    it "should raise an exception if the url is invalid"
  end
  
  context "the find_by_url method if 404 error" do
    before(:each) do
      stub_request(:any, @url).to_return(:body => "", :status => 404)
    end
    
    it "should return an empty list if something goes wrong" do
      ImdbVoteHistory.find_by_url(@url).should have(0).movies
    end
  end
  
  context "the find_by_id method" do
    it "should be possible to pass an id"
  end
end