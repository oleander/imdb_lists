# describe Container::Movie do
#   before(:each) do
#     @movie = Container::Movie.new(:imdb_link => "/title/tt1022603/")
#   end
#   
#   it "should raise an exception if the method isn't found" do
#     @movie.should_receive(:movie).any_number_of_times.and_return(ImdbParty::Imdb.new)
#     lambda { @movie.some_random_method }.should raise_error(NoMethodError)
#   end
#   
#   it "should have a valid valid? method" do
#     ["/title/tt1022603/"].each do |url|
#       Container::Movie.new(:imdb_link => url).should be_valid
#     end
#     
#     ["/title/aa1022603/", "title/tt1022603", "/title/tt0/", "", nil].each do |url|
#       Container::Movie.new(:imdb_link => url).should_not be_valid
#     end
#   end
#   
#   it "should return the right imdb link" do
#     @movie.imdb_link.should eq("http://www.imdb.com/title/tt1022603/")
#   end
#   
#   it "should return an imdb id" do
#     @movie.imdb_id.should eq("tt1022603")
#   end
#   
#   it "should be able to cache requests" do
#     MovieSearcher.should_receive(:find_movie_by_id).with("tt1022603").exactly(1).times.and_return(ImdbParty::Movie.new)
#     10.times { @movie.title }
#   end
#   
#   it "should raise error if the movie doesn't exists" do
#     MovieSearcher.should_receive(:find_movie_by_id).with("tt1022603").exactly(2).times
#     lambda { @movie.title }.should raise_error(ArgumentError)
#   end
# end