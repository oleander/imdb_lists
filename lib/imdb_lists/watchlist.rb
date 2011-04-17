require "nokogiri"
require "rest-client"
require "imdb_lists/container"

module ImdbLists
  class Watchlist
    attr_reader :url, :id
  
    # Ingoing argument is the id to fetch movies from.
    def initialize(id)
      @movies = []
      @url    = "http://www.imdb.com/list/#{id}"
      @id = id
    end
  
    # The owners username, nil if the page doesn't exists.
    def user
      content.at_css(".byline a").content
    rescue NoMethodError
      nil # The default value if no user i found
    end
    
    def title
      @_title ||= content.at_css("h1").content
      @_title == "Newest Lists" ? nil : @_title
    end
    
    # Returns a list of movies of the Container::Movie type.
    def movies
      prepare! unless @movies.any?; @movies
    end
  
    private
      def prepare!
        movies = []; content.css(".title a").each do |movie|
          movie = Container::Movie.new(:imdb_link => movie.attr("href"))
          @movies << movie if movie.valid?
        end
      end
    
      def inner_url
        "#{@url}/?view=compact&sort=listorian:asc"
      end
    
      def download
        RestClient.get(inner_url, :timeout => 10)
      rescue => error
        raise error unless false
      end

      def content
        @content ||= Nokogiri::HTML(download)
      end
  end
end