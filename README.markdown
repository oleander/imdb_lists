# IMDb Lists

Get easy access to any public [IMDb](http://www.imdb.com/) [vote history list](http://www.imdb.com/mymovies/list?l=19736607) and [watchlist](http://www.imdb.com/list/2BZy80bxY2U) using Ruby.

## How to use

### Find by url

    $ require 'rubygems'
    $ require 'imdb_lists'
    
    $ result = ImdbLists::find_by_url("http://www.imdb.com/mymovies/list?l=32558051")
    
    $ result.movies.count
    >> 937
    
    $ result.user
    >> "eddyproca" # Not me :)
    
    $ result.movies.last.title
    >> "The Last Man on Earth"
    
    $ result.movies.first.class
    >> Container::Movie
    
    $ result.movies.last.actors.first.name
    >> "Vincent Price"
    
### Find by id

    $ result = ImdbLists::find_by_id("32558051")
    
    $ result.movies.count
    >> 937
    
## Data to work with

### Accessors

- **user** (String) Owner of the list.
- **id** (Fixnum or String) A unique id for the list.
- **url** (String) Full URL to the IMDb list itself.
- **movies** (Array[Container::Movie]) A list of movies containing `Container::Movie` instances.
- **title** (String) Title of the watchlist.
- **valid?** (Boolean) Is the data that is being returned valid?

### The Container::Movie class

The `movies` method returns a list of `Container::Movie` objects, each object has two methods that returns information about the movie without doing another request to [IMDb](http://www.imdb.com/).

If you for example want to get the title of the movie you can apply the accessors that is being described [here](https://github.com/oleander/MovieSearcher).
Scroll down to the `ImdbParty::Movie` part to get information about the available accessors.

- **imdb_link** (String) The full URL to the IMDb page.
- **imdb_id** (String) The IMDb ID for the movie.

You can, as said above, use any method that `ImdbParty::Movie` provides directly from the `Container::Movie` object, like *title*, *year* and *actors*.

## How do install

    [sudo] gem install imdb_lists
    
## How to use it in a rails 3 project

Add `gem 'imdb_lists'` to your Gemfile and run `bundle`.

## Requirements

*IMDb Lists* is tested in OS X 10.6.6 using Ruby 1.9.2 and 1.8.7.

## Thanks to

[Chicago_gangster](http://www.imdb.com/user/ur13279695/boards/profile/) for solving the [pagination problem](http://www.imdb.com/board/bd0000041/thread/178983592?d=178983592&p=1#178983592).

## License

*IMDb Lists* is released under the MIT license.