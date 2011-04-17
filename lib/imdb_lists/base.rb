require "abstract"

module ImdbLists
  class Base    
    def download
      RestClient.get(inner_url, :timeout => 10)
    rescue RestClient::Exception => error
      warn "Error: #{error}, Where: #{error.backtrace.first}"
    end
    
    def inner_url
      not_implemented
    end
    
    def content
      @content ||= Nokogiri::HTML(download)
    end
    
    def movies
      prepare! unless @movies.any?; @movies
    end
    
    # Returns a list of movies of the Container::Movie type.
    def prepare!
      not_implemented
    end
  end
end