require "rspec"
require "webmock/rspec"
require "imdb_vote_history"
require "imdb_vote_history/container"
require "imdb_vote_history/history"

RSpec.configure do |config|
  config.mock_with :rspec
end