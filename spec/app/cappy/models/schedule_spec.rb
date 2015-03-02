require 'spec_helper'

describe Cappy::Models::Schedule do
  describe '.not_expired' do
    let(:cutoff) { Time.new(2015, 02, 28, 10, 00, 00) }

    let!(:schedule_one) do
      create(:schedule, :hourly,
             start_time: Time.mktime(0),
             end_time: cutoff - 1.hour)
    end
    let!(:schedule_two) do
      create(:schedule, :hourly,
             start_time: Time.mktime(0),
             end_time: cutoff + 1.hour)
    end
    let!(:schedule_three) do
      create(:schedule, :hourly,
             start_time: Time.mktime(0))
    end

    it 'returns schedule two and three' do
      expect(described_class.not_expired(cutoff)).to eq([schedule_two, schedule_three])
    end
  end
end
