# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "imdb_lists"
  s.version     = "1.0.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleander.nu"]
  s.homepage    = "https://github.com/oleander/imdb_lists"
  s.summary     = %q{Get easy access to any public IMDb vote history list using Ruby}
  s.description = %q{Get easy access to any public IMDb vote history list. Extract information from each movie like; title, release date, rating, actors}

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
