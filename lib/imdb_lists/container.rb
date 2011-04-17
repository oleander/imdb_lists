require "movie_searcher"

module Container
  class Movie
    def initialize(args)
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
        
    # Returns the imdb id for the movie.
    # Example:
    # => tt0066026
    def imdb_id
      imdb_link.match(/(tt\d+)/).to_a[1]
    end
    
    # Returns the full imdb url for the movie.
    # Example:
    # => www.imdb.com/title/tt0066026/
    def imdb_link
      "http://www.imdb.com#{@imdb_link}"  
    end
    
    # Does the container contains a valid imdb url?
    # Return true if the url is valid.
    # Example on valid url:
    # => www.imdb.com/title/tt0066026/
    def valid?
      !! imdb_link.match(/http:\/\/www\.imdb\.com\/title\/tt\d{2,}/i)
    end
    
    def method_missing(method, *args)
      return movie.send(method, *args) if exists? and movie.methods.include?(prepare(method))
      raise exists? ? NoMethodError.new("Undefined method '#{method}' for #{movie.class}") : ArgumentError.new("The imdb #{imdb_id} is invalid")
    end
    
    private
      def exists?
        ! movie.nil?
      end
      
      def movie
        @movie ||= MovieSearcher.find_movie_by_id(imdb_id)
      end
      
      def prepare(method)
        RUBY_VERSION.to_s.match(/1\.9/) ? method.to_sym : method.to_s
      end
  end
end