# Imdb Vote History

Get access to all movies on your imdb vote history page.

[Here](http://www.imdb.com/mymovies/list?l=19736607) is an example of a imdb vote history, not mine tho. 

## How to use

### Find by url

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
    
### Find by id

    $ result = ImdbVoteHistory.find_by_id("32558051")
    
    $ result.movies.count
    >> 937
    
## What data to with with

### The ImdbVoteHistory class

When you use the `find_by_url` of `find_by_id` method a `ImdbVoteHistory` object will be returned.

The class it self has some few accessors that might be useful.

- **user** (String) The owner/creator of the list.
- **id** (Fixnum) A unique id for the list
- **movies** (Array<Container::Movie>) A list of movies containing `Container::Movie` instances.

### A list of movies (a.k.a the Container::Movie class)

The list of movies that is being returned by the `movies` method makes it's possible to fetch usable data from [IMDB](http://www.imdb.com/).

Read more about the API [here](https://github.com/oleander/MovieSearcher).

## How do install

    [sudo] gem install imdb_vote_history
    
## How to use it in a rails 3 project

Add `gem 'imdb_vote_history'` to your Gemfile and run `bundle`.

## Requirements

*IMDB Vote History* is tested in OS X 10.6.6 using Ruby 1.9.2 and 1.8.7.

## Thanks to

[Chicago_gangster](http://www.imdb.com/user/ur13279695/boards/profile/) for solving the [pagination problem](http://www.imdb.com/board/bd0000041/thread/178983592?d=178983592&p=1#178983592).

## License

*IMDB Vote History* is released under the MIT license.