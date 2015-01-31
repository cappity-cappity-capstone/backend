require 'spec_helper'
require 'date'

describe Cappy::Models::State do
  describe '#valid?' do
    let(:device) { build(:lock) }
    let(:device_id) { device.id }
    let(:state) { 1 }
    let(:source) { 'scheduled' }

    before { device.save }

    subject do
      described_class.new(
        device_id: device_id,
        state: state,
        source: source
      )
    end

    context 'when the device_id is nil' do
      let(:device_id) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when the device_id is not nil' do
      context 'but the state is nil' do
        let(:state) { nil }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end

      context 'and the state is not nil' do
        context 'but the source is nil' do
          let(:source) { nil }

          it 'is not valid' do
            expect(subject).to_not be_valid
          end
        end

        context 'and the source is not nil' do
          context 'but the source is an invalid value' do
            let(:source) { 'new_source_type' }

            it 'is not valid' do
              expect(subject).to_not be_valid
            end
          end

          context 'and the source is a valid value' do
            Cappy::Models::State::VALID_SOURCES.each do |v_s|
              let(:source) { v_s }

              it 'is valid' do
                expect(subject).to be_valid
              end
            end
          end
        end
      end
    end
  end
end
