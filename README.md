# IMDb Lists

Get easy access to any public [IMDb](http://www.imdb.com/) [movie list](http://www.imdb.com/lists).

## How to use

### Find by url

``` ruby
require "imdb_lists"
result = ImdbLists.fetch("http://www.imdb.com/user/ur10777143/ratings")

result.movies.count # => 693
result.movies.first.title # => Die Hard
```

## Data to work with

### Accessors
 
- **name** (String) List name.
- **url** (String) Full URL to the IMDb list itself.
- **movies** (Array) A list of movies.

### A movie object

The `movies` method returns a list of movies.
 
- **id** (String) IMDb movie id.
- **title** (String) Movie title.
- **directors** (Array< String >) A list of directors.
- **rating** (Fixnum) Movie rating, from 0.0 to 10.0.
- **runtime** (Fixnum) Runtime in minutes.
- **genres** (Array< String >) A list of genres.
- **votes** (Fixnum) The amount of votes.
- **released_at** (Time) When was the movie released?
- **details** A url to the [IMDb details](http://www.imdb.com/title/tt0095016/) page.
- **created_at** When was it added to the given list?

#### Only for vote lists (like in the example)

- **you_rated** (Fixnum) Your rating, from 0.0 to 10.0.
 
## How do install

    [sudo] gem install imdb_lists
    
## How to use it in a rails 3 project

Add `gem 'imdb_lists'` to your Gemfile and run `bundle`.

## Requirements

*IMDb Lists* is tested in OS X 10.6.6, 10.7.1 using Ruby 1.9.2.

## License

*IMDb Lists* is released under the MIT license.