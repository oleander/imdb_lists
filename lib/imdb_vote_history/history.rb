require "nokogiri"
require "rest-client"
require "imdb_vote_history/container"

module ImdbLists
  class History
    attr_reader :url
  
    # Ingoing argument is the id to fetch movies from.
    def initialize(id)
      @movies = []
      @url    = "http://www.imdb.com/mymovies/list?l=#{id}"
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
end