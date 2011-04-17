require "nokogiri"
require "rest-client"
require "imdb_lists/container"
require "imdb_lists/base"

module ImdbLists
  class History < ImdbLists::Base
    attr_reader :url, :id
  
    # Ingoing argument is the id to fetch movies from.
    def initialize(id)
      @movies = []
      @url    = "http://www.imdb.com/mymovies/list?l=#{@id = id.to_i}"
    end
  
    # The owners username, nil if the page doesn't exists.
    def user
      content.at_css(".blurb a:nth-child(1)").content
    rescue NoMethodError
      nil # The default value if no user i found
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
  end
end