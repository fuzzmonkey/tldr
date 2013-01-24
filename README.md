# Tldr

A gem for (tldr.io](http://tldr.io). You will need an API client name & key to access the search. Details of which can be found at on the [tldr api documentation.](http://tldr.io/api-documentation)

## Installation

Add this line to your application's Gemfile:

    gem 'tldr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tldr

## Usage

Create a client

	client = Tldr::API.new('api_client_name','api_client_key')

### Latest Articles

	client.latest n

Where n is the number of latest articles to return, maximum 10.
	
### Search

	client.search url

Where url is the URL of the article you want to search for a tldr for.

### Batch Search
Not implemented

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
