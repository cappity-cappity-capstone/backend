FactoryGirl.define do
  factory :schedule, class: Cappy::Models::Schedule do
    factory :schedule_forever_from_now do
      start_time { Time.now }
    end

    trait :hourly do
      interval 60 * 60
    end

    trait :daily do
      interval 60 * 60 * 24
    end

    factory :schedule_ends_immediately do
      start_time { Time.now }
      end_time { start_time }
      interval 0
    end
  end
end
