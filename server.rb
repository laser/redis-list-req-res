require 'redis'
require 'json'

class Server
  def initialize(list_name)
    client = Redis.new

    # don't block the parent thread
    @thread = Thread.new do

      while true
        # pop last element off our list in a blocking fashion
        channel, request = client.brpop(list_name, timeout: 5)

        parsed = JSON.parse request

        # reverse the message we were sent
        response = {
          'message' => parsed['message'].reverse
        }

        # 'respond' by inserting our reply at the head of a 'reply'-list
        client.lpush(parsed['reply_to'], JSON.generate(response))
      end
    end
  end
end
