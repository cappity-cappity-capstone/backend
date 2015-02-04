# Build a factory for each device type

FactoryGirl.define do
  factory :device, class: Cappy::Models::Device do
    sequence(:device_id) { |n| "DEVICE-#{n}" }
    sequence(:name) { |n| "NAME-#{n}" }

    Cappy::Models::Device::VALID_DEVICE_TYPES.each do |device_type|
      factory device_type do
        device_type device_type
        last_check_in { Time.now }
      end
    end
  end
end
