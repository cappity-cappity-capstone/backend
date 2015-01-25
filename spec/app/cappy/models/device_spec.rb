require 'spec_helper'
require 'date'

describe Cappy::Models::Device do
  describe '#valid?' do
    let(:device_id)     { 'DEADBEEF' }
    let(:name)          { 'Cabinet' }
    let(:device_type)   { 'lock' }
    let(:last_check_in) { DateTime.now }
    let(:created_at)    { DateTime.now - 1 }
    let(:updated_at)    { DateTime.now - 1 }

    valid_types = %w{lock outlet gas_valve airbourne_alert}

    subject { described_class.new(device_id: device_id,
                                  name: name, 
                                  device_type: device_type,
                                  last_check_in: last_check_in,
                                  created_at: created_at,
                                  updated_at: updated_at ) }

    context 'when the device_id is nil' do
      let(:device_id) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when the device_id is not nil' do
      context 'but the name is nil' do
        let(:name) { nil }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end

      context 'and the name is not nil' do
        context 'but the device_type is nil' do
          let(:device_type) { nil }

          it 'is not valid' do
            expect(subject).to_not be_valid
          end
        end

        context 'and the device_type is not nil' do
          context 'but the device_type is an invalid value' do
            let(:device_type) { "new_type" }

            it 'is not valid' do
              expect(subject).to_not be_valid
            end
          end

          context 'and the device_type is a valid value' do
            valid_types.each do |d_t|
              let(:device_type) { d_t }

              it 'is valid' do
                expect(subject).to be_valid
              end
            end
          end

          context 'but the last_check_in is nil' do
            let(:last_check_in) { nil }

            it 'is not valid' do
              expect(subject).to_not be_valid
            end
          end

          context 'but the last_check_in is before created_at' do
            let(:last_check_in) { created_at - 1 }

            it 'is not valid' do
              expect(subject).to_not be_valid
            end
          end

          context 'and the last_check_in is not nil' do
            it 'is valid' do
              expect(subject).to be_valid
            end
          end
        end
      end
    end
  end
end