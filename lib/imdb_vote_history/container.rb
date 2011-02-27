require "movie_searcher"

module Container
  class Movie < MovieSearcher    
    def initialize(args)
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
    
    def missing_method(method, *args, &block)
      @movie ||= MovieSearcher.find_movie_by_id(imdb_id)
    end
    
    def imdb_id
      imdb_link.match(/(tt\d+)/)[1]
    end
    
    def imdb_link
      "http://www.imdb.com" + @imdb_link  
    end
    
    def valid?
      !! imdb_link.match(/http:\/\/www\.imdb\.com\/title\/tt\d+/i)
    end
  end
end