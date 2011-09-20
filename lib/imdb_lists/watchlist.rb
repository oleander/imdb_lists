# require "nokogiri"
# require "rest-client"
# require "imdb_lists/container"
# require "imdb_lists/base"
# 
# module ImdbLists
#   class Watchlist < ImdbLists::Base
#     attr_reader :url, :id
#   
#     # Ingoing argument is the id to fetch movies from.
#     def initialize(id)
#       @url    = "http://www.imdb.com/list/#{@id = id}"
#       @movies = []
#     end
#   
#     # The owners username, nil if the page doesn't exists.
#     def user
#       content.at_css(".byline a").content
#     rescue NoMethodError
#       nil # The default value if no user i found
#     end
#     
#     def title
#       @_title ||= content.at_css("h1").content
#       ["Newest Lists", "Page not found"].include?(@_title) ? nil : @_title
#     rescue NoMethodError
#       nil # Default name if not found
#     end
#     
#     def valid?
#       ! [title, user].any?(&:nil?)
#     end
#     
#     private
#       def prepare!
#         movies = []; content.css(".title a").each do |movie|
#           movie = Container::Movie.new(:imdb_link => movie.attr("href"))
#           @movies << movie if movie.valid?
#         end
#       end
#     
#       def inner_url
#         "#{@url}/?view=compact&sort=listorian:asc"
#       end
#   end
# end