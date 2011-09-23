require "nokogiri"
require "rest-client"
require "uri"
require "titleize"
require "csv"
require "time"
require "imdb_lists/object"

class ImdbLists
  attr_reader :url
  
  #
  # @url String A valid IMDb list url
  # Like this; http://www.imdb.com/list/qJi7_i3l25Y/
  #
  def initialize(url)
    @url = url
    @movie = Struct.new(
      :id, 
      :created_at, 
      :title, 
      :directors, 
      :you_rated, 
      :rating, 
      :runtime, 
      :year, 
      :genres, 
      :votes, 
      :released_at, 
      :details,
      :order
    )
  end
  
  #
  # @url String A valid IMDb list url.
  # @return ImdbLists object.
  # Like this; http://www.imdb.com/list/qJi7_i3l25Y/
  # Raises an ArgumentError if the given url is invalid. 
  #
  def self.fetch(url)
    this = ImdbLists.new(url)
    unless this.is_url_valid?
      raise ArgumentError.new("Invalid url")
    end
        
    return this
  end
  
  #
  # @return String A url to the CVS file.
  #
  def csv
    if csv = content.at_css(".export a").try(:attr, "href")
      @_csv ||= "http://www.imdb.com%s" % csv
    end
  end
  
  #
  # @return String Name for the given list.
  #
  def name
    @_user ||= content.at_css("h1.header").try(:content)
  end
  
  #
  # @return Array<Movie> A list of movies
  #
  def movies
    return @_movies if @_movies
    return [] unless csv
    vote_list = csv_content.first.count != 15
          
    @_movies ||= csv_content[1..-1].map do |movie|
      if vote_list
        create_movie_from_vote_list(movie)
      else
        create_movie_from_regular_list(movie)
      end
    end
  end
  
  #
  # Is @url a valid url?
  # @return Boolean Valid?
  #
  def is_url_valid?
    !! @url.to_s.match(url_validator)
  end
  
  private
    #
    # Trying to parse the given string {time}
    # IMDb sometimes returns a strange string
    # This is why this method exists
    # @time String Should be parseable by Time.parse
    # @return Time An time object
    #
    def parse_time(time)
      if time =~ /^(\d{4})$/
        return Time.parse("#{$1}-01-01")
      elsif time =~ /(\d{4}-\d{2})/
        return Time.parse("#{$1}-01")
      end
      
      Time.parse(time)
    end
    
    #
    # Converting the given list of values to a movie object
    # This is for a regular list; http://www.imdb.com/list/qJi7_i3l25Y/
    # @movie Array<String> A list of values
    # @return A Struct Movie object.
    #
    def create_movie_from_regular_list(movie)
      @movie.new(
      movie[1],                                 # id
      parse_time(movie[2]),                     # created_at
      movie[5].titleize,                        # title
      movie[7].split(", "),                     # directors
      nil,                                      # you_rated
      movie[8].to_f,                            # rating
      movie[9].to_i,                            # runtime
      movie[10].to_i,                           # year
      movie[11].split(", ").map(&:titleize),    # genres
      movie[12].to_i,                           # votes
      parse_time(movie[13]),                    # released_at
      movie[14],                                # details
      movie[0].to_i                             # order
      )
    end
    
    #
    # Converting the given list of values to a movie object
    # This is for a vote history list; http://www.imdb.com/user/ur10777143/ratings
    # @movie Array<String> A list of values
    # @return A Struct Movie object.
    #
    def create_movie_from_vote_list(movie)
      @movie.new(
      movie[1],                                 # id
      parse_time(movie[2]),                     # created_at
      movie[5].titleize,                        # title
      movie[7].split(", "),                     # directors
      movie[8].to_f,                            # you_rated
      movie[9].to_f,                            # rating
      movie[10].to_i,                           # runtime
      movie[11].to_i,                           # year
      movie[12].split(", ").map(&:titleize),    # genres
      movie[13].to_i,                           # votes
      parse_time(movie[14]),                    # released_at
      movie[15],                                # details
      movie[0].to_i                             # order
      )
    end
    
    def url_validator
      /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/
    end
    
    def csv_raw
      @_csv_raw ||= RestClient.get(csv, timeout: 10)
    end
    
    def csv_content
      @_csv_content ||= CSV.parse(csv_raw)
    end
    
    def content
      @_content ||= Nokogiri::HTML(data) 
    end
    
    def data
      @_data ||= RestClient.get(@url, timeout: 10)
    end
end
