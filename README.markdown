# IMDb Vote History

Access all movies on any public IMDb vote history page.

[Here](http://www.imdb.com/mymovies/list?l=19736607) is an example of a list, not mine tho. 

## How to use

### Find by url

    $ require 'rubygems'
    $ require 'imdb_vote_history'
    
    $ result = ImdbVoteHistory.find_by_url("http://www.imdb.com/mymovies/list?l=32558051")
    
    $ result.movies.count
    >> 937
    
    $ result.user
    >> "eddyproca" # Not me :)
    
    $ result.movies.last.title
    >> "The Last Man on Earth"
    
    $ result.class
    >> ImdbVoteHistory
    
    $ result.movies.first.class
    >> Container::Movie
    
    $ result.movies.last.actors.first.name
    >> "Vincent Price"
    
### Find by id

    $ result = ImdbVoteHistory.find_by_id("32558051")
    
    $ result.movies.count
    >> 937
    
## Data to work with

### The ImdbVoteHistory class

When you use the `find_by_url` and `find_by_id` method a `ImdbVoteHistory` object gets returned.

The object it self has a few accessors that might be useful.

- **user** (String) Owner of the list.
- **id** (Fixnum) A unique id for the list.
- **url** (String) Full URL to the IMDb vote history list that was parsed.
- **movies** (Array<Container::Movie>) A list of movies containing `Container::Movie` instances.

### The Container::Movie class

The `movies` method returns a list of `Container::Movie` objects, each object has two methods that returns information about the movie without doing another request to [IMDb](http://www.imdb.com/).

If you for example want to get the title of the movie you can apply the accessors that is being described [here](https://github.com/oleander/MovieSearcher).
Scroll down to the `ImdbParty::Movie` part to get information about the available accessors.

- **imdb_link** (String) The full URL to the IMDb page.
- **imdb_id** (String) The IMDb ID for the movie.

You can, as said above, use any method that `ImdbParty::Movie` provides directly from the `Container::Movie` object, like *title*, *year* and *actors*.

## How do install

    [sudo] gem install imdb_vote_history
    
## How to use it in a rails 3 project

Add `gem 'imdb_vote_history'` to your Gemfile and run `bundle`.

## Requirements

*IMDb Vote History* is tested in OS X 10.6.6 using Ruby 1.9.2 and 1.8.7.

## Thanks to

[Chicago_gangster](http://www.imdb.com/user/ur13279695/boards/profile/) for solving the [pagination problem](http://www.imdb.com/board/bd0000041/thread/178983592?d=178983592&p=1#178983592).

## License

*IMDb Vote History* is released under the MIT license.