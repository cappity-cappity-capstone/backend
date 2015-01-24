require 'spec_helper'

describe Cappy::Controllers::Version do
  include Rack::Test::Methods

  let(:app) { described_class.new }

  describe 'GET /version' do
    it 'returns a 200 with the application version' do
      get '/version'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(Cappy::VERSION)
    end
  end
end
