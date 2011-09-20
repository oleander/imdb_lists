require "nokogiri"
require "rest-client"
require "uri"

class ImdbLists
  def initialize(url)
    @url = url
  end
    
  def self.fetch(url)
    il = ImdbLists.new(url)
    unless il.is_url_valid?
      raise ArgumentError.new("Invalid url")
    end
    
    il.fetch_and_parse!
  end
  
  def fetch_and_parse!
    
  end
  
  def is_url_valid?
    !! @url.to_s.match(url_validator)
  end
  
  private    
    def url_validator
      /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/
    end
end
