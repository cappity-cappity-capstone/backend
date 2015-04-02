require 'spec_helper'

describe Cappy::Controllers::Tasks do
  include Rack::Test::Methods

  let(:app) { described_class.new }
  let(:device_one) { create(:lock) }
  let(:device_two) { create(:outlet) }

  describe 'GET /tasks/' do
    let(:task_one) { build(:task, device: device_one) }
    let(:task_two) { build(:task, device: device_two) }
    let(:tasks) { [task_one, task_two].sort_by(&:id) }

    before { tasks.each(&:save!) }

    it 'returns a list of every task' do
      get '/tasks/'

      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to eq('application/json')
      expect(JSON.parse(last_response.body).sort_by { |hash| hash['id'] })
        .to eq(tasks.map { |t| t.as_json.merge('schedules' => []) })
    end
  end

  describe 'GET /devices/DEVICE_ID/tasks/' do
    let(:task_one) { build(:task, device: device_one) }
    let(:task_two) { build(:task, device: device_two) }
    let(:tasks) { [task_one, task_two].sort_by(&:id) }

    before { tasks.each(&:save!) }

    it 'returns a list of every task' do
      get "/devices/#{device_one.device_id}/tasks/"

      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to eq('application/json')
      expect(JSON.parse(last_response.body)[0]).to eq(task_one.as_json.merge('schedules' => []))
    end
  end

  describe 'POST /tasks/DEVICE_ID' do
    context 'when invalid data is POSTed' do
      let(:hash) { { goo_goo: 'ga_ga' } }

      it 'returns a "400 Client Error"' do
        post "/tasks/#{device_one.device_id}/", hash.to_json

        expect(last_response.status).to eq(400)
      end
    end

    context 'when valid data is POSTed' do
      let(:task) { build(:task) }
      let(:json) { task.to_json }
      let(:body) { JSON.parse(last_response.body) }

      it 'returns a "201 Created"' do
        post "/tasks/#{device_one.device_id}/", json

        expect(last_response.status).to eq(201)
        expect(body['state']).to eq(task.state.to_s('F'))
        expect(body['device_id']).to eq(device_one.id)
      end
    end
  end

  describe 'GET /tasks/TASK_ID/' do
    context 'when the TASK_ID does not exist' do
      it 'returns a "404 Not Found"' do
        get '/tasks/does_not_exist/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the TASK_ID exists' do
      let(:task) { build(:task, device: device_one) }

      before { task.save! }

      it 'returns that task' do
        get "/tasks/#{task.id}/"

        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq(task.as_json)
      end
    end
  end

  describe 'PUT /tasks/TASK_ID/' do
    context 'when the TASK_ID does not exist' do
      it 'returns a "404 Not Found"' do
        put '/tasks/does_not_exist', { start_time: Time.now }.to_json

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the TASK_ID exists' do
      let(:task) { build(:task, device: device_one) }

      before { task.save! }

      context 'but invalid data is PUT' do
        it 'returns a "400 Client Error"' do
          put "/tasks/#{task.id}/", { age: 'Kitchen' }.to_json

          expect(last_response.status).to eq(400)
        end
      end

      context 'and valid data is PUT' do
        it 'updates that task' do
          put "/tasks/#{task.id}/", { state: 1.0 }.to_json

          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe 'DELETE /tasks/TASK_ID/' do
    context 'when the TASK_ID does not exist' do
      it 'returns a "404 Not Found"' do
        delete '/tasks/does_not_exist/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'when the TASK_ID exists' do
      let(:task) { create(:task, device: device_one) }
      let(:task_id) { task.id }

      it 'deletes that task' do
        delete "/tasks/#{task_id}/"

        expect(last_response.status).to eq(204)
        expect { Cappy::Services::Tasks.read(task_id) }
          .to raise_error(Cappy::Errors::NoSuchObject)
      end
    end
  end
end
