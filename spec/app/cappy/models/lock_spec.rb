require 'spec_helper'

describe Cappy::Models::Lock do
  describe '#valid?' do
    let(:name) { 'Cabinet' }
    let(:device_id) { 'DEADBEEF' }
    let(:status) { true }

    subject { described_class.new(name: name, device_id: device_id, status: status) }

    context 'when the name is nil' do
      let(:name) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when the name is not nil' do
      context 'but the device_id is nil' do
        let(:device_id) { nil }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end

      context 'and the device_id is not nil' do
        context 'but the status is nil' do
          let(:status) { nil }

          it 'is not valid' do
            expect(subject).to_not be_valid
          end
        end

        context 'and the status is not nil' do
          it 'is valid' do
            expect(subject).to be_valid
            subject.save!
          end
        end
      end
    end
  end
end
