require "rspec"
require "webmock/rspec"
require "imdb_vote_history"
require "imdb_vote_history/container"

RSpec.configure do |config|
  config.mock_with :rspec
end