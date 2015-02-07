require 'spec_helper'
require 'pry'

describe Cappy::Controllers::Schedules do
  include Rack::Test::Methods

  let(:app) { described_class.new }
  let(:device_one) { create(:lock) }
  let(:device_two) { create(:outlet) }

  describe 'GET /schedules/' do
    let(:schedule_one) { build(:schedule_ends_immediately, :hourly, device: device_one) }
    let(:schedule_two) { build(:schedule_forever_from_now, :hourly, device: device_two) }
    let(:schedules) { [schedule_one, schedule_two].sort_by(&:id) }

    before { schedules.each(&:save!) }

    it 'returns a list of every schedule' do
      get '/schedules/'

      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to eq('application/json')
      expect(JSON.parse(last_response.body).sort_by { |hash| hash['id'] })
        .to eq(schedules.map(&:as_json))
    end
  end

  describe 'GET /devices/DEVICE_ID/schedules/' do
    let(:schedule_one) { build(:schedule_ends_immediately, :hourly, device: device_one) }
    let(:schedule_two) { build(:schedule_forever_from_now, :hourly, device: device_two) }
    let(:schedules) { [schedule_one, schedule_two].sort_by(&:id) }

    before { schedules.each(&:save!) }

    it 'returns a list of every schedule' do
      get "/devices/#{device_one.device_id}/schedules/"

      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to eq('application/json')
      expect(JSON.parse(last_response.body)[0]).to eq(schedule_one.as_json)
    end
  end

  describe 'POST /schedules/DEVICE_ID' do
    context 'when invalid data is POSTed' do
      let(:hash) { { goo_goo: 'ga_ga' } }

      it 'returns a "400 Client Error"' do
        post "/schedules/#{device_one.device_id}/", hash.to_json

        expect(last_response.status).to eq(400)
      end
    end

    context 'when valid data is POSTed' do
      let(:schedule) { build(:schedule_ends_immediately) }
      let(:json) { schedule.to_json }
      let(:body) { JSON.parse(last_response.body) }

      it 'returns a "201 Created"' do
        post "/schedules/#{device_one.device_id}/", json

        expect(last_response.status).to eq(201)
        expect(body['start_time']).to eq(schedule.start_time.utc.iso8601)
        expect(body['device_id']).to eq(device_one.id)
      end
    end
  end

  describe 'GET /schedules/SCHEDULE_ID/' do
    context 'when the SCHEDULE_ID does not exist' do
      it 'returns a "404 Not Found"' do
        get '/schedules/does_not_exist/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the SCHEDULE_ID exists' do
      let(:schedule) { build(:schedule_ends_immediately, device: device_one) }

      before { schedule.save! }

      it 'returns that schedule' do
        get "/schedules/#{schedule.id}/"

        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq(schedule.as_json)
      end
    end
  end

  describe 'PUT /schedules/SCHEDULE_ID/' do
    context 'when the SCHEDULE_ID does not exist' do
      it 'returns a "404 Not Found"' do
        put '/schedules/does_not_exist', { start_time: Time.now }.to_json

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the SCHEDULE_ID exists' do
      let(:schedule) { build(:schedule_ends_immediately, device: device_one) }

      before { schedule.save! }

      context 'but invalid data is PUT' do
        it 'returns a "400 Client Error"' do
          put "/schedules/#{schedule.id}/", { age: 'Kitchen' }.to_json

          expect(last_response.status).to eq(400)
        end
      end

      context 'and valid data is PUT' do
        it 'updates that schedule' do
          put "/schedules/#{schedule.id}/", { start_time: Time.now }.to_json

          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe 'DELETE /schedules/SCHEDULE_ID/' do
    context 'when the SCHEDULE_ID does not exist' do
      it 'returns a "404 Not Found"' do
        delete '/schedules/does_not_exist/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the SCHEDULE_ID exists' do
      let(:schedule) { create(:schedule_ends_immediately, device: device_one) }
      let(:schedule_id) { schedule.id }

      it 'deletes that schedule' do
        delete "/schedules/#{schedule_id}/"

        expect(last_response.status).to eq(204)
        expect { Cappy::Services::Schedules.read(schedule_id) }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end
  end
end
