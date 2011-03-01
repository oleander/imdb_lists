describe ImdbVoteHistory do
  before(:all) do
    @url          = "http://www.imdb.com/mymovies/list?l=32558051"
    @valid_urls   = ["http://imdb.com/mymovies/list?l=123431", "imdb.com/mymovies/list?l=3212312351", "www.imdb.com/mymovies/list?l=31231251"]
    @invalid_urls = ["http://www.imdb.com/mymovieslist?l=32558051", "mymovieslist?l=32558051", "http://www.imdb.com/mymovieslist?l=32558abc051"]
    @count        = 937
  end
  
  after(:each) do
    WebMock.reset!
  end
  
  context "the find_by_url method if success" do
    before(:each) do
      stub_request(:get, "#{@url}&a=1").to_return(:body => File.new("spec/fixtures/32558051.html"), :status => 200)
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
    
    it "should contain a list of movies" do
      ImdbVoteHistory.find_by_url(@url).movies.all? {|m| m.should be_instance_of(Container::Movie) }
    end
    
    it "should raise an exception if the url is invalid" do
      @invalid_urls.each do |url|
        lambda { ImdbVoteHistory.find_by_url(url) }.should raise_error(ArgumentError)
      end
      
      @valid_urls.each do |url|
        lambda { ImdbVoteHistory.find_by_url(url) }.should_not raise_error(ArgumentError)
      end
    end
  end
  
  context "the find_by_url method if 404 error" do    
    before(:each) do
      stub_request(:get, "#{@url}&a=1").to_return(:body => "", :status => 404)
    end
    
    it "should return an empty list if something goes wrong" do
      ImdbVoteHistory.find_by_url(@url).movies.should be_empty
    end
    
    it "should not return a user" do
      ImdbVoteHistory.find_by_url(@url).user.should be_nil
    end
  end
  
  context "the find_by_id method" do
    it "should be possible to pass an id" do
      [0, nil, "", "0"].each do |id|
        lambda { ImdbVoteHistory.find_by_id(id) }.should raise_error(ArgumentError)
      end
      
      ["32558051", 32558051].each do |id|
        lambda { ImdbVoteHistory.find_by_id(id) }.should_not raise_error(ArgumentError)
      end
    end
  end
end