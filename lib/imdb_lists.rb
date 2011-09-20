require "nokogiri"
require "rest-client"
require "uri"

class ImdbLists
  def initialize(url)
    @url = url
  end
    
  def self.fetch(url)
    this = ImdbLists.new(url)
    unless this.is_url_valid?
      raise ArgumentError.new("Invalid url")
    end
    
    this.fetch_and_parse!
    
    return this
  end
  
  def fetch_and_parse!
    # http://www.imdb.com/user/ur10777143/ratings
  end
  
  def cvs
    @_cvs ||= "http://www.imdb.com" + content.at_css(".export a").attr("href")
  end
  
  def name
    @_user ||= content.at_css("h1.header").content
  end
  
  def is_url_valid?
    !! @url.to_s.match(url_validator)
  end
  
  private    
    def url_validator
      /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/
    end
    
    def content
      @_content ||= Nokogiri::HTML(data) 
    end
    
    def data
      @_data ||= RestClient.get(@url)
    end
end
