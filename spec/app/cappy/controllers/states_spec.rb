require 'spec_helper'
require 'pry'

describe Cappy::Controllers::States do
  include Rack::Test::Methods

  let(:app) { described_class.new }

  describe 'GET /devices/DEVICE_ID/state/' do
    context 'when the DEVICE_ID does not exist' do
      it 'returns a "404 not found"' do
        get '/devices/does_not_exist/state/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the DEVICE_ID exists' do
      let(:device) { create(:lock) }
      let(:device_id) { device.device_id }
      let!(:state) { create(:on_state, :scheduled, device: device) }

      it 'reads the last state' do
        get "/devices/#{device_id}/state/"

        expect(last_response.status).to eq(200)
        expect(device.last_check_in).to eq(state.created_at)
        expect(JSON.parse(last_response.body)).to eq(state.as_json)
      end
    end
  end

  describe 'POST /devices/DEVICE_ID/state/' do
    context 'when the DEVICE_ID does not exist' do
      it 'returns a "404 not found"' do
        post '/devices/does_not_exist/state/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the DEVICE_ID exists' do
      let(:device) { create(:lock) }
      let(:device_id) { device.device_id }
      let(:hash) { { state: '0.0', source: 'manual_override' } }

      it 'creates a new last state' do
        post "/devices/#{device_id}/state/", hash.to_json

        expect(last_response.status).to eq(201)
        expect(JSON.parse(last_response.body))
          .to eq(device.states.last.as_json)
      end
    end
  end
end
