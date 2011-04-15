require "nokogiri"
require "rest-client"
require "imdb_lists/container"
require "imdb_lists/history"

module ImdbLists  
  # Fetches movies for the given URL.
  # Returns an ImdbVoteHistory object.
  # The URL must be valid, otherwise an argument error will be raised.
  # Example of valid URL:
  # => http://www.imdb.com/mymovies/list?l=32558051
  # => http://www.imdb.com/list/2BZy80bxY2U
  def self.find_by_url(url)
    url = url.to_s
    if url =~ /imdb\.com\/mymovies\/list\?l=(\d{2,})/i
      ImdbLists::History.new($1)
    elsif url =~ /imdb\.com\/list\/([^\/]+)/i
      ImdbLists::Watchlist.new($1)
    else
      raise ArgumentError.new("The url #{url} is invalid")
    end
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
