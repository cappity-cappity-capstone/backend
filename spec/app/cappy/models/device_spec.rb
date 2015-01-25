require 'spec_helper'
require 'date'

describe Cappy::Models::Device do
  describe '#valid?' do
    let(:device_id) { 'DEADBEEF' }
    let(:name) { 'Cabinet' }
    let(:device_type) { 'lock' }
    let(:last_check_in) { DateTime.now }
    let(:created_at) { DateTime.now - 1 }
    let(:updated_at) { DateTime.now - 1 }

    subject { described_class.new(device_id: device_id,
                                  name: name, 
                                  device_type: device_type,
                                  last_check_in: last_check_in,
                                  created_at: created_at,
                                  updated_at: updated_at ) }

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
        context 'but the device_type is nil' do
          let(:device_type) { nil }

          it 'is not valid' do
            expect(subject).to_not be_valid
          end
        end

        context 'and the device_type is not nil' do          
          it 'is valid' do
            expect(subject).to be_valid
            subject.save!
          end
        end
      end
    end
  end
end