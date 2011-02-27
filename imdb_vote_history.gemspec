# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "imdb_vote_history"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleande.nu"]
  s.homepage    = ""
  s.summary     = %q{Get easy access to all your movies on the imdb vote history page}
  s.description = %q{Get easy access to all your movies on the imdb vote history page using Ruby}

  s.rubyforge_project = "imdb_vote_history"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("rest-client")
  s.add_dependency("nokogiri")
  s.add_dependency("movie_searcher")
  
  s.add_development_dependency("rspec")
  s.add_development_dependency("webmock")
end
