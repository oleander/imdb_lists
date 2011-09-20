require "nokogiri"
require "rest-client"
require "uri"
require "csv"

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
  
  def csv
    @_csv ||= "http://www.imdb.com" + content.at_css(".export a").attr("href")
  end
  
  def name
    @_user ||= content.at_css("h1.header").content
  end
  
  def movies
    csv_content[1..-1]
  end
  
  def is_url_valid?
    !! @url.to_s.match(url_validator)
  end
  
  private
  
    def csv_raw
      @_csv_raw ||= RestClient.get(csv, timeout: 10)
    end
    
    def csv_content
      @_csv_content ||= CSV.parse(csv_raw)
    end
    
    def url_validator
      /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/
    end
    
    def content
      @_content ||= Nokogiri::HTML(data) 
    end
    
    def data
      @_data ||= RestClient.get(@url, timeout: 10)
    end
end
