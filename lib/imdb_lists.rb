require "nokogiri"
require "rest-client"
require "uri"
require "titleize"
require "csv"
require "time"

class ImdbLists
  attr_reader :url
  
  def initialize(url)
    @url = url
    @movie = Struct.new(
      :id, 
      :created_at, 
      :title, 
      :directors, 
      :you_rated, 
      :rating, 
      :runtime, 
      :year, 
      :genres, 
      :votes, 
      :released_at, 
      :details
    )
  end
    
  def self.fetch(url)
    this = ImdbLists.new(url)
    unless this.is_url_valid?
      raise ArgumentError.new("Invalid url")
    end
        
    return this
  end
  
  def csv
    @_csv ||= "http://www.imdb.com" + content.at_css(".export a").attr("href")
  end
  
  def name
    @_user ||= content.at_css("h1.header").content
  end
  
  def movies
    csv_content[1..-1].map do |movie|
      @movie.new(
      movie[1],
      parse_time(movie[2]),
      movie[5].titleize,
      movie[7].split(", "),
      movie[8].to_f,
      movie[9].to_f,
      movie[10].to_i,
      movie[11].to_i,
      movie[12].split(", ").map(&:titleize),
      movie[13].to_i,
      parse_time(movie[14]),
      movie[15]
      )
    end
  end
  
  def is_url_valid?
    !! @url.to_s.match(url_validator)
  end
  
  private
  
    def parse_time(time)
      if time =~ /^(\d{4})$/
        return Time.parse("#{$1}-01-01")
      elsif time =~ /(\d{4}-\d{2})/
        return Time.parse("#{$1}-01")
      end
      
      Time.parse(time)
    end
    
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
