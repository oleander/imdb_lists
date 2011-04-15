require "rspec"
require "webmock/rspec"
require "imdb_lists"
require "imdb_lists/container"
require "imdb_lists/history"
require "imdb_lists/watchlist"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.mock_with :rspec
end