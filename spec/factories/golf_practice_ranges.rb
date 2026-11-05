FactoryBot.define do
  factory :golf_practice_range do
    name { "テストゴルフ練習場" }
    city { "東大阪市" }
    address { "大阪府東大阪市テスト町1-1" }
    opening_hours { "9:00〜22:00" }
    parking_available { true }
    floor_count { 2 }
    booth_count { 50 }
    yard_length { 200 }
  end
end
