require 'spec_helper'
require 'pry'

describe Cappy::Controllers::Devices do
  include Rack::Test::Methods

  let(:app) { described_class.new }

  describe 'GET /devices/' do
    let(:device_one) { build(:lock) }
    let(:device_two) { build(:gas_valve) }
    let(:devices) { [device_one, device_two].sort_by(&:id)  }
    let(:expected) { devices.map { |d| { device: d }.as_json } }

    before { devices.each(&:save!) }

    it 'returns a list of every device' do
      get '/devices/'

      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to eq('application/json')
      expect(JSON.parse(last_response.body).sort_by { |hash| hash['device']['id'] }).to eq(expected)
    end
  end

  describe 'POST /devices/' do
    context 'when invalid data is POSTed' do
      let(:hash) { { goo_goo: 'ga_ga' } }

      it 'returns a "400 Client Error"' do
        post '/devices/', hash.to_json

        expect(last_response.status).to eq(400)
      end
    end

    context 'when valid data is POSTed' do
      context 'but that device already exists' do
        let(:device) { create(:lock) }
        let(:json) { device.as_json.tap { |hash| hash.delete('id') }.to_json }

        it 'returns a "409 Conflict"' do
          post '/devices/', json

          expect(last_response.status).to eq(409)
        end
      end

      context 'and that device does not exist' do
        let(:device) { build(:gas_valve) }
        let(:json) { device.to_json.except('current_state') }

        it 'returns a "201 Created"' do
          post '/devices/', json

          expect(last_response.status).to eq(201)
          expect(JSON.parse(last_response.body)['device']['device_id']).to eq(device.device_id)
        end
      end
    end
  end

  describe 'GET /devices/DEVICE_ID/' do
    context 'when the DEVICE_ID does not exist' do
      it 'returns a "404 Not Found"' do
        get '/devices/does_not_exist/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the DEVICE_ID exists' do
      let(:device) { build(:airbourne_alert) }

      before { device.save! }

      it 'returns that device' do
        get "/devices/#{device.device_id}/"

        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq('device' => device.as_json)
      end
    end
  end

  describe 'PUT /devices/DEVICE_ID/' do
    context 'when the DEVICE_ID does not exist' do
      it 'returns a "404 Not Found"' do
        put '/devices/does_not_exist', { name: 'Kitchen' }.to_json

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the DEVICE_ID exists' do
      let(:device) { build(:outlet) }

      before { device.save! }

      context 'but invalid data is PUT' do
        it 'returns a "400 Client Error"' do
          put "/devices/#{device.device_id}/", { age: 'Kitchen' }.to_json

          expect(last_response.status).to eq(400)
        end
      end

      context 'and valid data is PUT' do
        it 'updates that device' do
          put "/devices/#{device.device_id}/", { name: 'Kitchen' }.to_json

          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe 'DELETE /devices/DEVICE_ID/' do
    context 'when the DEVICE_ID does not exist' do
      it 'returns a "404 Not Found"' do
        delete '/devices/does_not_exist/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the DEVICE_ID exists' do
      let(:device) { create(:lock) }
      let(:device_id) { device.device_id }

      it 'deletes that device' do
        delete "/devices/#{device_id}/"

        expect(last_response.status).to eq(204)
        expect { Cappy::Services::Devices.read(device_id) }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end
  end

  describe 'PUT /devices/DEVICE_ID/watchdog/' do
    context 'when the DEVICE_ID does not exist' do
      it 'returns a "404 not found"' do
        put '/devices/does_not_exist/watchdog/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the DEVICE_ID exists' do
      let(:device) { create(:lock) }
      let(:device_id) { device.device_id }

      before do
        device.last_check_in = Time.mktime(0)
        device.save!
      end

      it 'updates the last_check_in time' do
        expect do
          put "/devices/#{device_id}/watchdog/"

          expect(last_response.status).to eq(200)
        end.to change { device.tap(&:reload).last_check_in }
      end
    end
  end
end
