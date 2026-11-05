FactoryBot.define do
  factory :ball_price do
    association :golf_practice_range

    day_type { :weekday }
    price_per_ball { 10.0 }
    floor_number { nil }
    start_time { nil }
    end_time { nil }
  end
end
