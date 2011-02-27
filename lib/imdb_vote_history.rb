require "nokogiri"
require "rest-client"
require "imdb_vote_history/container"

class ImdbVoteHistory
  attr_accessor :movies
  def self.find_by_url(url)
    this = ImdbVoteHistory.new(url)
    this.prepare!
    return this
  end
  
  def initialize(url)
    @url = url
  end
  
  def download
    @download ||= RestClient.get(@url, :timeout => 10) rescue ""
  end
  
  def user
    content.at_css(".blurb a:nth-child(1)").content
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
  end
end
