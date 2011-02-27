require "nokogiri"
require "rest-client"
require "imdb_vote_history/container"

class ImdbVoteHistory
  attr_accessor :movies
  def self.find_by_url(url)
    ImdbVoteHistory.new(url).prepare!
  end
  
  def self.find_by_id(id)
    self.find_by_url("http://www.imdb.com/mymovies/list?l=#{id}")
  end
  
  def initialize(url)
    raise ArgumentError.new("The url #{url} is invalid") unless url.to_s.match(/(http:\/\/)?(w{3}\.)?imdb\.com\/mymovies\/list\?l=\d{2,}/)
    @url = url
  end
  
  def download
    @download ||= RestClient.get(@url, :timeout => 10) rescue ""
  end
  
  def user
    begin
      content.at_css(".blurb a:nth-child(1)").content
    rescue NoMethodError
      "" # The default value if no user i found
    end
  end
  
  def id
    @url.match(/list\?l=(\d+)/).to_a[1].to_i
  end
  
  def content 
    @content ||= Nokogiri::HTML download
  end
  
  def prepare!
    return @movies unless @movies.nil?
    
    @movies = []
    
    content.css("td.standard a").each do |movie|
      movie = Container::Movie.new(:imdb_link => movie.attr("href"))
      @movies << movie if movie.valid?
    end
    
    return self
  end
end
