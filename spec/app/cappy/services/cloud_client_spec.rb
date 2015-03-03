require 'spec_helper'

# Note: If you're going to re-record the VCRs, make run an auth server with an
# empty database on port 4567.
describe Cappy::Services::CloudClient do
  let(:host) { 'http://localhost:4567' }
  subject { described_class.new(host) }

  let(:uuid) { 'SOME-UUID' }
  let(:port) { 4567 }

  describe '#create' do
    context 'when an invalid UUID or port is POSTed' do
      let(:uuid) { nil }

      it 'raises a CloudClientError', :vcr do
        expect { subject.create(uuid, port) }
          .to raise_error(Cappy::Errors::CloudClientError)
      end
    end

    context 'when valid data is POSTed' do
      context 'but the control server has already been created in the cloud' do
        let(:uuid) { 'DUPLICATED-UUID' }

        before { subject.create(uuid, port) }

        it 'raises a CloudClientError', :vcr do
          expect { subject.create(uuid, port) }
            .to raise_error(Cappy::Errors::CloudClientError)
        end
      end

      context 'and the UUID is new to the cloud server' do
        let(:expected) { { 'uuid' => uuid, 'port' => port } }

        it 'returns the parsed JSON response', :vcr do
          expect(subject.create(uuid, port)).to match(a_hash_including(expected))
        end
      end
    end
  end

  describe '#update' do
    context 'when an invalid UUID or port is PUT' do
      let(:port) { nil }

      it 'raises a CloudClientError', :vcr do
        expect { subject.update(uuid, port) }
          .to raise_error(Cappy::Errors::CloudClientError)
      end
    end

    context 'when valid data is PUT' do
      context 'but the UUID is new to the cloud server' do
        let(:uuid) { 'NEW-UUID' }

        it 'raises a CloudClientError', :vcr do
          expect { subject.update(uuid, port) }
            .to raise_error(Cappy::Errors::CloudClientError)
        end
      end

      context 'and the control server has already been created in the cloud' do
        let(:expected) { { 'port' => port, 'uuid' => uuid } }

        it 'returns the parsed JSON response', :vcr do
          expect(subject.update(uuid, port)).to match(a_hash_including(expected))
        end
      end
    end
  end
end
