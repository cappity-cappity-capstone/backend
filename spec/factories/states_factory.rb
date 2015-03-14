FactoryGirl.define do
  factory :off_state, class: Cappy::Models::State do
    device
    state 0
  end

  factory :on_state, class: Cappy::Models::State do
    device
    state 1
  end

  Cappy::Models::State::VALID_SOURCES.each do |source|
    trait source do
      source source
    end
  end
end
