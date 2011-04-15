require "spec_helper"

describe ImdbLists::Watchlist do
  before(:all) do
    @url          = "http://www.imdb.com/list/2BZy80bxY2U"
    @id           = "2BZy80bxY2U"
    @count        = 79
    @full_url     = "http://www.imdb.com/list/2BZy80bxY2U/?view=compact&sort=listorian:asc"
  end
  
  before(:each) do
    @ivh = ImdbLists::Watchlist.new(@id)
  end
  
  context "200 success - internet" do
    before(:each) do
      stub_request(:get, @full_url).to_return(:body => File.read("spec/fixtures/watchlist.html"), :status => 200)
    end
    
    it "should return a list of movies" do
      @ivh.should have(@count).movies
    end
    
    it "should have a user method" do
      @ivh.user.should eq("savagestreets")
    end
    
    it "should have a title" do
      @ivh.title.should eq("My favorite movies of alltime! some of them are so bad, but so f....g brilliant")
    end
    
    after(:each) do
      a_request(:get, @full_url).should have_been_made
    end

  end
  
  describe "offline" do
    it "should have a id method" do
      @ivh.id.should eq("2BZy80bxY2U")
    end
    
    it "should have an url method" do
      @ivh.url.should eq(@url)
    end
  end
    
  context "empty list" do
    before(:each) do
       stub_request(:get, @full_url).to_return(:body => File.new("spec/fixtures/empty_watchlist.html"), :status => 200)
     end
     
    it "should return an empty list" do
      @ivh.should have(0).movies
    end
    
    it "should not have a user" do
      @ivh.user.should eq("Oleeander")
    end
    
    it "should have an id" do
      @ivh.id.should eq("2BZy80bxY2U")
    end
  end
  
  context "non public" do
    before(:each) do
       stub_request(:get, @full_url).to_return(:body => File.new("spec/fixtures/non_public_watchlist.html"), :status => 200)
     end
     
    it "should return an empty list" do
      @ivh.should have(0).movies
    end
    
    it "should not have a user" do
      @ivh.user.should be_nil
    end
    
    it "should have an id" do
      @ivh.id.should eq("2BZy80bxY2U")
    end
  end
  
  context "the find_by_id method" do
    it "should be possible to pass an id" do
      ImdbLists::Watchlist.should_receive(:new).with("2BZy80bxY2U")
      lambda { ImdbLists::find_by_id("2BZy80bxY2U") }.should_not raise_error(ArgumentError)
    end
  end
  
  context "the find_by_url method" do    
    it "should not raise an error if the url is valid" do
      ImdbLists::Watchlist.should_receive(:new).exactly(2).times.with("2BZy80bxY2U")
      lambda { ImdbLists::find_by_url(@full_url) }.should_not raise_error(ArgumentError)
      lambda { ImdbLists::find_by_url(@url) }.should_not raise_error(ArgumentError)
    end
  end
end