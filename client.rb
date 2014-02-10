require 'redis'
require 'securerandom'
require 'json'
require 'pry'

class Client
  def initialize(list_name)
    @list_name = list_name
    @client = Redis.new
  end

  def request(message)

    # reply-to tells the server where we'll be listening
    request = {
      'reply_to' => 'reply-' + SecureRandom.uuid,
      'message'  => message
    }

    # insert our request at the head of the list
    @client.lpush(@list_name, JSON.generate(request))

    # pop last element off our list in a blocking fashion
    channel, response = @client.brpop(message['reply_to'], timeout=30)

    JSON.parse(response)['message']
  end
end
