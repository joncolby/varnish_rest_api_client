# VarnishRestApiClient

The varnish rest api client is a command-line client program to call the varnish_rest_api.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'varnish_rest_api_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install varnish_rest_api_client

## Usage

```
varnishapiclient.rb

Commands:
  varnishapiclient.rb help [COMMAND]  # Describe available commands or one specific command
  varnishapiclient.rb in BACKEND      # set health of this varnish BACKEND to auto
  varnishapiclient.rb list PATTERN    # display all varnish backends
  varnishapiclient.rb out BACKEND     # set health of this varnish BACKEND to sick.
  varnishapiclient.rb show            # show varnish nodes registered with zookeeper

Options:
  V, [--varnish=varnish1:10001 varnish2:10001]  # varnish nodes(s)
  z, [--zkserver=ZKSERVER]      # zookeeper server:port
                                # Default: autodeploy38-2:2181
  P, [--zkpath=ZKPATH]          # zookeeper varnish root path
                                # Default: /varnish
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/varnish_rest_api_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
