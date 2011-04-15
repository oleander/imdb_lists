describe ImdbVoteHistory do
  before(:all) do
    @url          = "http://www.imdb.com/mymovies/list?l=32558051"
    @id           = "32558051" 
    @count        = 937
    
    @valid_urls   = [
      "http://imdb.com/mymovies/list?l=1234", 
      "imdb.com/mymovies/list?l=1234", 
      "www.imdb.com/mymovies/list?l=1234"
    ]
    
    @invalid_urls = [
      "http://www.imdb.com/mymovieslist?l=32558051", 
      "mymovieslist?l=32558051", 
      "http://www.imdb.com/mymovieslist?l=32558abc051"
    ]
  end
  
  after(:each) do
    WebMock.reset!
  end
  
  before(:each) do
    @ivh = ImdbVoteHistory.new(@id)
  end
  
  context "200 success" do
    before(:each) do
      stub_request(:get, "#{@url}&a=1").to_return(:body => File.new("spec/fixtures/32558051.html"), :status => 200)
    end
    
    it "should return a list of movies" do
      @ivh.should have(@count).movies
    end
    
    it "should be able to cache" do
      object = Container::Movie.new(:imdb_link => "http://www.imdb.com/title/tt0460649/")
      Container::Movie.should_receive(:new).exactly(@count).times.and_return(object)
      10.times { @ivh.movies }
    end
    
    it "should have a user method" do
      @ivh.user.should eq("eddyproca")
    end
    
    it "should have a id method" do
      @ivh.id.should eq(32558051)
    end
    
    it "should contain a list of movies" do
      @ivh.movies.all? { |m| m.should be_instance_of(Container::Movie) }
    end
    
    it "should have an url method" do
      @ivh.url.should eq(@url)
    end
  end
  
  context "404 error" do    
    before(:each) do
      stub_request(:get, "#{@url}&a=1").to_return(:body => "", :status => 404)
    end
    
    it "should return an empty list if something goes wrong" do
      @ivh.movies.should be_empty
    end
    
    it "should not return a user" do
      @ivh.user.should be_nil
    end
  end
  
  context "a non public list" do
    before(:each) do
       stub_request(:get, "#{@url}&a=1").to_return(:body => File.new("spec/fixtures/non_public.html"), :status => 200)
     end
     
    it "should return an empty list" do
      @ivh.should have(0).movies
    end
    
    it "should not have a user" do
      @ivh.user.should be_nil
    end
    
    it "should have an id" do
      @ivh.id.should eq(32558051)
    end
  end
  
  context "the find_by_id method" do
    it "should be possible to pass an id" do
      ["32558051", 32558051].each do |id|
        ImdbVoteHistory.should_receive(:new).with(id)
        lambda { ImdbVoteHistory.find_by_id(id) }.should_not raise_error(ArgumentError)
      end
    end
    
    it "should not be possible to pass nil or n <= 9" do
     ["0", nil, "1", "string", "9"].each do |id|
        lambda { ImdbVoteHistory.find_by_id(id) }.should raise_error(ArgumentError)
      end
    end
  end
  
  context "the find_by_url method" do
    it "should raise an error if the url is invalid" do
      ImdbVoteHistory.should_not_receive(:new)
      @invalid_urls.each do |url|
        lambda { ImdbVoteHistory.find_by_url(url) }.should raise_error(ArgumentError)
      end
    end
    
    it "should not raise an error if the url is valid" do
      ImdbVoteHistory.should_receive(:new).with("1234").exactly(@valid_urls.length).times
      @valid_urls.each do |url|
        lambda { ImdbVoteHistory.find_by_url(url) }.should_not raise_error(ArgumentError)
      end
    end
  end
  
  context "watchlist" do
    before(:each) do
      @url = "http://www.imdb.com/list/2BZy80bxY2U/?view=compact&sort=listorian:asc"
    end
    
    it "should not raise an error when a watchlist list being passed" do
      lambda { ImdbVoteHistory.find_by_url(@url) }.should_not raise_error(ArgumentError)
    end
  end
end