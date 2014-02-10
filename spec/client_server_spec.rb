require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'blocking request / response' do
  channel = 'foo'

  before(:all) do
    r = Redis.new
    r.del channel
  end

  it 'does what I want it to do' do
    client = Client.new channel
    server = Server.new channel

    response = client.request('america')
    expect(response).to eq('acirema')
  end
end
