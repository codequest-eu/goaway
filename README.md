# GoAway

GoAway is a very simple authorization tool that authorizes users to access
your application based on how they respond to control checks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'goaway'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install goaway

## Usage

Include GoAway module wherever you need authorization. The only prerequisite is that the
scope MUST provide a `current_user` method or variable - otherwise GoAway will
throw an error. An example of a fairly typical use in a Rails app:

```ruby
class ResourcesController
  include GoAway

  def index
    authorize :resource_owner
    render json: serialized_resources
  end
end
```

In the above example `current_user` will be authorized to retrieve resources if
it responds to `resource_owner?` with `true`. If `resource_owner?` method is not
implemented for `current_user` or it returns `false`, `authorize` will raise a
GoAway::NotAuthorizedError with `'You are not authorized to perform this request!'` message.

If you want or need to authorize your users based on more complex checks, for example
you want the resource owner to access only the specific resources they own, you can pass the
checker methods and their arguments as keyword arguments, provided that they are
passed last, after all checks without arguments:

```ruby
class ResourcesController
  include GoAway

  def index
    authorize :admin, resource_owner: params[:resource_id]
    render json: serialized_resources
  end
end
```

This will authorize users who respond with `true` to `admin?` or to
`resource_owner?(resource_id)`.

You can pass more arguments to the checker method by enclosing them in an array:

```ruby
authorize :admin, resource_owner: [arg_1, arg_2]
```

GoAway however was not put together with very complex checks in mind: if you
require more complicated authorization, this might not be a tool for you.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/codequest-eu/goaway.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
