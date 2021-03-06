# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "imdb_lists"
  s.version     = "2.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleander.nu"]
  s.homepage    = "https://github.com/oleander/imdb_lists"
  s.summary     = %q{Get easy access to any public IMDb list}
  s.description = %q{Get easy access to any public IMDb list, such as; Watchlists and Vote history lists. Extract information from each movie like; title, release date, rating, actors}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("rest-client")
  s.add_dependency("nokogiri")
  s.add_dependency("titleize")
  
  s.add_development_dependency("vcr")
  s.add_development_dependency("rspec")
  s.add_development_dependency("webmock")
  
  s.required_ruby_version = ">= 1.9.2"
end
