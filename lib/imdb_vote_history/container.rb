require "movie_searcher"

module Container
  class Movie < MovieSearcher    
    def initialize(args)
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
    
    def method_missing(method, *args)
      return movie.send(method, *args) if exists? and movie.methods.include?(method.to_s)
      raise exists? ? NoMethodError.new : ArgumentError.new("The imdb #{imdb_id} is invalid")
    end
    
    def imdb_id
      imdb_link.match(/(tt\d+)/).to_a[1]
    end
    
    def imdb_link
      "http://www.imdb.com#{@imdb_link}"  
    end
    
    def valid?
      !! imdb_link.match(/http:\/\/www\.imdb\.com\/title\/tt\d{2,}/i)
    end
    
    def exists?
      ! movie.nil?
    end
    
    private
      def movie
        @movie ||= MovieSearcher.find_movie_by_id(imdb_id)
      end
  end
end