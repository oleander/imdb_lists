require "nokogiri"
require "rest-client"
require "imdb_vote_history/container"

class ImdbVoteHistory
  # Ingoing argument is the url to fetch movies from.
  # Must be valid, otherwise an argument error will be raised.
  # Example on valid URL:
  # => http://www.imdb.com/mymovies/list?l=32558051
  def initialize(url)
    raise ArgumentError.new("The url #{url} is invalid") unless url.to_s.match(/(http:\/\/)?(w{3}\.)?imdb\.com\/mymovies\/list\?l=\d{2,}/)
    @page    = 0
    @movies  = []
    @url     = url
    @content = {}
  end
  
  # Fetches movies for the given URL.
  # Raises an exception if the url is invalid.
  # Returns and ImdbVoteHistory object.
  def self.find_by_url(url)
    ImdbVoteHistory.new(url)
  end
  
  # Fetches movies for the given ID.
  # Raises an exception if the url is invalid.
  # Returns and ImdbVoteHistory object.
  def self.find_by_id(id)
    find_by_url("http://www.imdb.com/mymovies/list?l=#{id}")
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
    url.match(/list\?l=(\d+)/).to_a[1].to_i
  end
  
  # Fetches the {value} page.
  # Take one argument, of type Fixnum.
  def page(value)
    @page = value * 10; self
  end
  
  # Should we fetch all movies, even though pagination exists?
  def all
    @all = self
  end
  
  # Returns a list of movies of the Container::Movie type.
  def movies
    prepare! unless @movies.any?; @movies
  end
  
  private
    def prepare!
      movies = []; content.css("td.standard a").each do |movie|
        movie = Container::Movie.new(:imdb_link => movie.attr("href"))
        movies << movie if movie.valid?
      end
        
      @movies += movies; prepare! if @all and movies.any? and step! and not done?
    end
    
    def done?
      not content.content.empty? and total_results == current_results
    end

    def total_results
      content.at_css(".standard:nth-child(1)").content.match(/: (\d+)/).to_a[1]
    end

    def results
      current_results.to_i - current_display[1].to_i + 1
    end

    def current_results
      current_display[2]
    end

    def current_display
      content.at_css("tr:nth-child(2) .standard b:nth-child(1)").content.match(/(\d+)-(\d+)/)
    end
    
    def url
      @page.zero? ? @url : "#{@url}&o=#{@page}"
    end
    
    def step!
      @page += 10
    end
    
    def download
      RestClient.get(url, :timeout => 10) rescue ""
    end

    def content
      @content[@page] ||= Nokogiri::HTML download
    end
end
