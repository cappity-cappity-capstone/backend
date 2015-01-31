# Build a factory for each device type

Cappy::Models::Device::VALID_DEVICE_TYPES.each do |device_type|
  FactoryGirl.define do
    factory device_type, class: Cappy::Models::Device do
      sequence(:device_id) { |n| "DEVICE-#{n}" }
      sequence(:name) { |n| "NAME-#{n}" }
      device_type device_type
      last_check_in { Time.now }
    end
  end
end
