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
    
    it "should have a list of movies" do
      @list.movies.each do |movie|
        movie.id.should match(/tt\d{7}/)
        movie.created_at.should be_instance_of(Time)
        movie.title.should_not be_empty
        movie.directors.should be_instance_of(Array)
        movie.you_rated.should be_between(0, 10)
        movie.rating.should be_between(0, 10)
        movie.runtime.should >= 0
        movie.year.should > 1900
        movie.genres.map(&:titleize).should eq(movie.genres)
        movie.votes.should > 1
        movie.released_at.should be_instance_of(Time)
        movie.details.should match(/^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/)
      end
    end
    
    it "should be able to cache a request" do
      2.times { @list.name }
      a_request(:get, "http://www.imdb.com/user/ur10777143/ratings").should have_been_made.once
    end
  end
end