require "abstract"

module ImdbLists
  class Base    
    def download
      RestClient.get(inner_url, :timeout => 10)
    rescue RestClient::Exception => error
      @errors == true ? raise(error) : warn("Error: #{error}, Where: #{error.backtrace.first}")
    end
    
    def content
      @content ||= Nokogiri::HTML(download)
    end
    
    def movies
      prepare! unless @movies.any?; @movies
    end
    
    def errors(boolean)
      tap { @errors = boolean }
    end
    
    def prepare!
      not_implemented
    end
    
    def inner_url
      not_implemented
    end
  end
end