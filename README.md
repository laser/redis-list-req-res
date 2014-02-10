redis-list-req-res
==================

Emulating HTTP request / response with blocking pop on a Redis list.

Motivations
-----------

I'd like to replace HTTP as the transport mechanism for a SOA project, but
preserve the request / response semantics. I'd like to be able to write code
that looked like this:

```ruby
class UsersController
  def index
    @users = UserService.get_all_users
  end
end
```

...and have the UserService client use Redis as a transport mechanism to
communicate between the UserService implementation and consumer - without the
consumer needing to know anything about HTTP, Redis, or whatever transport.

How's it work?
--------------

Basically, like this:

1. Server and client agree upon a channel name (this will be my service's name)
1. Server, upon initialization, starts an infinite loop in which it issues a
   blocking pop command on the channel. This is done in a new thread such that
   we don't block the client. In the real world, this would probably be handled
   by separating client and server into different processes.
1. Client sends a message on the channel name and then issues its own blocking
   pop on a new channel whose name is equal to the original channel with the
   string 'reply-' prepended
1. Server sends a message on the 'reply-' channel and continues to loop

Tests / Demo
------------

You need to make sure to start the Redis server before running the tests, which
you can do by running the command:

```
foreman start
```

Then, run the tests:

```
bundle exec rspec
```
