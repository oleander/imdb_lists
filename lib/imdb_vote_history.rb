require "nokogiri"
require "rest-client"
require "imdb_vote_history/container"
require "imdb_vote_history/history"

module ImdbLists  
  # Fetches movies for the given URL.
  # Returns an ImdbVoteHistory object.
  # The URL must be valid, otherwise an argument error will be raised.
  # Example of valid URL:
  # => http://www.imdb.com/mymovies/list?l=32558051
  def self.find_by_url(url)
    unless url.to_s.match(/^(http:\/\/)?(w{3}\.)?imdb\.com\/mymovies\/list\?l=\d{2,}$/)
      raise ArgumentError.new("The url #{url} is invalid")
    end
    ImdbLists::History.new(url.match(/list\?l=(\d+)/).to_a[1])
  end
  
  # Fetches movies for the given ID.
  # Returns an ImdbVoteHistory object.
  def self.find_by_id(id)
    if id.to_s.match(/^\d{2,}$/)
      ImdbLists::History.new(id)
    elsif id.to_s.match(/^\w{2,}$/)
      ImdbLists::Watchlist.new(id)
    else
      raise ArgumentError.new("The id #{id} is invalid")
    end
  end
end
