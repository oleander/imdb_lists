require "nokogiri"
require "rest-client"
require "imdb_vote_history/container"

class ImdbVoteHistory
  attr_reader :url
  
  # Ingoing argument is the id to fetch movies from.
  def initialize(id)
    @movies = []
    @url    = "http://www.imdb.com/mymovies/list?l=#{id}"
  end
  
  # Fetches movies for the given URL.
  # Returns an ImdbVoteHistory object.
  # The URL must be valid, otherwise an argument error will be raised.
  # Example of valid URL:
  # => http://www.imdb.com/mymovies/list?l=32558051
  def self.find_by_url(url)
    unless matchers.map{ |reg| url.to_s.match(reg) }.any?
      raise ArgumentError.new("The url #{url} is invalid")
    end
    ImdbVoteHistory.new(url.match(/list\?l=(\d+)/).to_a[1])
  end
  
  # Fetches movies for the given ID.
  # Returns an ImdbVoteHistory object.
  def self.find_by_id(id)
    raise ArgumentError.new("The id #{id} is invalid") unless id.to_s.match(/^\d{2,}$/)
    ImdbVoteHistory.new(id)
  end
  
  # The owners username, nil if the page doesn't exists.
  def user
    begin
      content.at_css(".blurb a:nth-child(1)").content
    rescue NoMethodError
      nil # The default value if no user i found
    end
  end
  
  # A unique id for this particular list.
  # Return type is Fixnum.
  def id
    @url.match(/list\?l=(\d+)/).to_a[1].to_i
  end
  
  # Should we fetch all movies, even though pagination exists?
  def all
    @all = self
  end
  
  # Returns a list of movies of the Container::Movie type.
  def movies
    prepare! unless @movies.any?; @movies
  end
  
  def self.matchers
    [/imdb\.com\/mymovies\/list\?l=\d{2,}$/, /\.imdb\.com\/list\/\w+/i]
  end
  private
    def prepare!
      movies = []; content.css("td.standard a").each do |movie|
        movie = Container::Movie.new(:imdb_link => movie.attr("href"))
        @movies << movie if movie.valid?
      end
    end
    
    def inner_url
      "#{@url}&a=1"
    end
    
    def download
      RestClient.get(inner_url, :timeout => 10) rescue ""
    end

    def content
      @content ||= Nokogiri::HTML download
    end
end
