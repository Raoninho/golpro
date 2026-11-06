# シティゴルフつるみ
range = GolfPracticeRange.find_by!(
  name: "シティゴルフつるみ"
)

prices = [
  { day_type: :weekday, floor_number: 1,
    start_time: "08:00", end_time: "12:00", price_per_ball: 11 },
  { day_type: :weekday, floor_number: 1,
    start_time: "12:00", end_time: "21:45", price_per_ball: 12 },
  { day_type: :weekday, floor_number: 2,
    start_time: "08:00", end_time: "12:00", price_per_ball: 10 },
  { day_type: :weekday, floor_number: 2,
    start_time: "12:00", end_time: "21:45", price_per_ball: 11 },
  { day_type: :weekend, floor_number: 1,
    start_time: nil, end_time: nil, price_per_ball: 14 },
  { day_type: :weekend, floor_number: 2,
    start_time: nil, end_time: nil, price_per_ball: 13 }
]

prices.each do |attributes|
  conditions = attributes.except(:price_per_ball)

  price = range.ball_prices.find_or_initialize_by(conditions)
  price.price_per_ball = attributes[:price_per_ball]
  price.save!
end

# 東大阪ゴルフセンター
# 通常チャージ：70球550円（約7.86円/球）
# 初回ICカード発行料：200円
# 利用時間：90分制
# 出典：https://gora.golf.rakuten.co.jp/practice-range/guide/647/

range = GolfPracticeRange.find_by!(
  name: "東大阪ゴルフセンター"
)

[ :weekday, :weekend ].each do |day_type|
  price = range.ball_prices.find_or_initialize_by(
    day_type: day_type,
    floor_number: nil,
    start_time: nil,
    end_time: nil
  )

  price.price_per_ball = 7.86
  price.save!
end

# 長吉ゴルフクラブ
# 出典：https://www.n-golfclub.com/cont9/main.html
# 早朝料金は開店〜9:00
# 開店時刻：4〜10月 6:30、11〜3月 7:00

range = GolfPracticeRange.find_by!(
  name: "長吉ゴルフクラブ"
)

prices = []

[ 1, 2, 3 ].each do |floor|
  prices << {
    day_type: :weekday,
    floor_number: floor,
    start_time: "06:30",
    end_time: "09:00",
    price_per_ball: 8
  }

  prices << {
    day_type: :weekday,
    floor_number: floor,
    start_time: "09:00",
    end_time: "17:00",
    price_per_ball: floor == 3 ? 9 : 10
  }

  prices << {
    day_type: :weekday,
    floor_number: floor,
    start_time: "17:00",
    end_time: "23:00",
    price_per_ball: floor == 3 ? 10 : 11
  }

  if floor == 3
    prices << {
      day_type: :weekend,
      floor_number: floor,
      start_time: "06:30",
      end_time: "23:00",
      price_per_ball: 10
    }
  else
    prices << {
      day_type: :weekend,
      floor_number: floor,
      start_time: "06:30",
      end_time: "09:00",
      price_per_ball: 10
    }

    prices << {
      day_type: :weekend,
      floor_number: floor,
      start_time: "09:00",
      end_time: "23:00",
      price_per_ball: 11
    }
  end
end

prices.each do |attributes|
  conditions = attributes.except(:price_per_ball)

  price = range.ball_prices.find_or_initialize_by(conditions)
  price.price_per_ball = attributes[:price_per_ball]
  price.save!
end

# 井高野ゴルフセンター
# 出典：https://itakano-golf.com/price/
# ICメンバーカード利用時の税込料金
# ICカード発行料・年会費無料

range = GolfPracticeRange.find_by!(
  name: "井高野ゴルフセンター"
)

prices = []

weekday_prices = {
  1 => [ 10.5, 13.8, 15.5 ],
  2 => [ 10.5, 13.8, 14.4 ],
  3 => [ 10.0, 12.0, 13.0 ]
}

weekend_prices = {
  1 => [ 13.0, 16.5 ],
  2 => [ 12.5, 16.5 ],
  3 => [ 12.0, 15.0 ]
}

weekday_times = [
  [ "04:00", "08:00" ],
  [ "08:00", "12:00" ],
  [ "12:00", "22:45" ]
]

weekend_times = [
  [ "04:00", "08:00" ],
  [ "08:00", "22:45" ]
]

weekday_prices.each do |floor, amounts|
  weekday_times.each_with_index do |(start_time, end_time), index|
    prices << {
      day_type: :weekday,
      floor_number: floor,
      start_time: start_time,
      end_time: end_time,
      price_per_ball: amounts[index]
    }
  end
end

weekend_prices.each do |floor, amounts|
  weekend_times.each_with_index do |(start_time, end_time), index|
    prices << {
      day_type: :weekend,
      floor_number: floor,
      start_time: start_time,
      end_time: end_time,
      price_per_ball: amounts[index]
    }
  end
end

prices.each do |attributes|
  conditions = attributes.except(:price_per_ball)

  price = range.ball_prices.find_or_initialize_by(conditions)
  price.price_per_ball = attributes[:price_per_ball]
  price.save!
end

# SKゴルフガーデン
# 一般ゲスト料金（税込）
# 出典：https://sk-golf.jp/charge.html
# 料金表にリライトカードの案内あり

range = GolfPracticeRange.find_by!(
  name: "SKゴルフガーデン"
)

prices = [
  { day_type: :weekday, floor_number: 1,
    start_time: "06:00", end_time: "11:00", price_per_ball: 11.55 },
  { day_type: :weekday, floor_number: 1,
    start_time: "11:01", end_time: "22:00", price_per_ball: 13.75 },
  { day_type: :weekday, floor_number: 2,
    start_time: "06:00", end_time: "11:00", price_per_ball: 10.45 },
  { day_type: :weekday, floor_number: 2,
    start_time: "11:01", end_time: "22:00", price_per_ball: 12.65 },
  { day_type: :weekend, floor_number: 1,
    start_time: "06:00", end_time: "10:00", price_per_ball: 13.75 },
  { day_type: :weekend, floor_number: 1,
    start_time: "10:01", end_time: "22:00", price_per_ball: 14.85 },
  { day_type: :weekend, floor_number: 2,
    start_time: "06:00", end_time: "10:00", price_per_ball: 12.65 },
  { day_type: :weekend, floor_number: 2,
    start_time: "10:01", end_time: "22:00", price_per_ball: 13.75 }
]

prices.each do |attributes|
  conditions = attributes.except(:price_per_ball)
  price = range.ball_prices.find_or_initialize_by(conditions)
  price.price_per_ball = attributes[:price_per_ball]
  price.save!
end

# 阪奈ゴルフ
# 一般料金（税込）
# 出典：https://www.hanna-golf.com/uchippanashi-renshujyou.html
# 2階は50球単位の販売
# プリペイドカードから引き落とし

range = GolfPracticeRange.find_by!(
  name: "阪奈ゴルフ"
)

prices = [
  { day_type: :weekday, floor_number: 1,
    start_time: nil, end_time: nil, price_per_ball: 10 },
  { day_type: :weekday, floor_number: 2,
    start_time: nil, end_time: nil, price_per_ball: 9 },
  { day_type: :weekend, floor_number: 1,
    start_time: nil, end_time: nil, price_per_ball: 11 },
  { day_type: :weekend, floor_number: 2,
    start_time: nil, end_time: nil, price_per_ball: 10 }
]

prices.each do |attributes|
  conditions = attributes.except(:price_per_ball)
  price = range.ball_prices.find_or_initialize_by(conditions)
  price.price_per_ball = attributes[:price_per_ball]
  price.save!
end

# 阪神ゴルフセンター 大正店・住之江店
# 一時利用料金（税込・全時間帯共通）
#
# 大正店：https://www.hanshingolf.com/taisyo/charge/index.php
# 住之江店：https://www.hanshingolf.com/suminoe/charge/index.php

hanshin_prices = {
  "阪神ゴルフセンター 大正店" => {
    weekday: 20.90,
    weekend: 25.30
  },
  "阪神ゴルフセンター 住之江店" => {
    weekday: 17.23,
    weekend: 18.15
  }
}

hanshin_prices.each do |range_name, day_prices|
  range = GolfPracticeRange.find_by!(name: range_name)

  day_prices.each do |day_type, amount|
    price = range.ball_prices.find_or_initialize_by(
      day_type: day_type,
      floor_number: nil,
      start_time: nil,
      end_time: nil
    )

    price.price_per_ball = amount
    price.save!
  end
end

# 忍ケ丘ゴルフセンター
# 一般料金：1,100円購入時の単価
# 平日 120球、土日祝 110球
# ICカード発行手数料：300円
# 出典：https://shinobugaokagolfcenter.com/price2/

range = GolfPracticeRange.find_by!(
  name: "忍ケ丘ゴルフセンター"
)

{
  weekday: (1100.0 / 120).round(2),
  weekend: (1100.0 / 110).round(2)
}.each do |day_type, amount|
  price = range.ball_prices.find_or_initialize_by(
    day_type: day_type,
    floor_number: nil,
    start_time: nil,
    end_time: nil
  )

  price.price_per_ball = amount
  price.save!
end

# 松原インターゴルフ
# 現金1,000円購入時の早朝料金
# 平日6:00〜9:00：94球
# 土日祝6:00〜8:00：85球
# 出典：https://inter-golf.jp/price.html

range = GolfPracticeRange.find_by!(
  name: "松原インターゴルフ"
)

prices = [
  {
    day_type: :weekday,
    floor_number: nil,
    start_time: "06:00",
    end_time: "09:00",
    price_per_ball: (1000.0 / 94).round(2)
  },
  {
    day_type: :weekend,
    floor_number: nil,
    start_time: "06:00",
    end_time: "08:00",
    price_per_ball: (1000.0 / 85).round(2)
  }
]

prices.each do |attributes|
  conditions = attributes.except(:price_per_ball)
  price = range.ball_prices.find_or_initialize_by(conditions)
  price.price_per_ball = attributes[:price_per_ball]
  price.save!
end

# PXG大阪ドライビングレンジ
# 一般料金（年齢・性別・スクール等の割引なし）
# ICカード新規発行料：300円
# 出典：https://gora.golf.rakuten.co.jp/practice-range/guide/1861
# 注意：公式画像料金表との最終照合後に登録する

range = GolfPracticeRange.find_by!(
  name: "PXG大阪ドライビングレンジ"
)

prices = [
  { day_type: :weekday, floor_number: 1,
    start_time: nil, end_time: nil, price_per_ball: 12 },
  { day_type: :weekday, floor_number: 2,
    start_time: nil, end_time: nil, price_per_ball: 11 },
  { day_type: :weekday, floor_number: 3,
    start_time: nil, end_time: nil, price_per_ball: 8 },
  { day_type: :weekend, floor_number: 1,
    start_time: nil, end_time: nil, price_per_ball: 14 },
  { day_type: :weekend, floor_number: 2,
    start_time: nil, end_time: nil, price_per_ball: 13 },
  { day_type: :weekend, floor_number: 3,
    start_time: nil, end_time: nil, price_per_ball: 10 }
]

prices.each do |attributes|
  conditions = attributes.except(:price_per_ball)
  price = range.ball_prices.find_or_initialize_by(conditions)
  price.price_per_ball = attributes[:price_per_ball]
  price.save!
end

# 星田ゴルフセンター
# 現金600円購入時の1球単価（税込）
# 出典：https://www.hoshida-gc.com/ballfee.html
# 月曜・木曜はサービスデー（祝日の場合は翌日）
# サービスデーの特別料金は別途対応予定

range = GolfPracticeRange.find_by!(
  name: "星田ゴルフセンター"
)

prices = [
  {
    day_type: :weekday,
    floor_number: nil,
    start_time: "06:00",
    end_time: "09:00",
    price_per_ball: (600.0 / 58).round(2)
  },
  {
    day_type: :weekday,
    floor_number: nil,
    start_time: "09:00",
    end_time: "23:30",
    price_per_ball: (600.0 / 52).round(2)
  },
  {
    day_type: :weekend,
    floor_number: nil,
    start_time: "06:00",
    end_time: "18:00",
    price_per_ball: (600.0 / 47).round(2)
  },
  {
    day_type: :weekend,
    floor_number: nil,
    start_time: "18:00",
    end_time: "23:30",
    price_per_ball: (600.0 / 52).round(2)
  }
]

prices.each do |attributes|
  conditions = attributes.except(:price_per_ball)
  price = range.ball_prices.find_or_initialize_by(conditions)
  price.price_per_ball = attributes[:price_per_ball]
  price.save!
end

# 桜宮ゴルフクラブ
# 一般料金（税込）
# 平日：12.1円/球、土日祝：14.3円/球
# 打席料金：終日550円（別途必要）
# 出典：https://sakuranomiyagc.co.jp/

range = GolfPracticeRange.find_by!(
  name: "桜宮ゴルフクラブ"
)

{
  weekday: 12.1,
  weekend: 14.3
}.each do |day_type, amount|
  price = range.ball_prices.find_or_initialize_by(
    day_type: day_type,
    floor_number: nil,
    start_time: nil,
    end_time: nil
  )

  price.price_per_ball = amount
  price.save!
end

# 河内ゴルフ倶楽部
# ゴルフメドレー掲載の参考料金
# 1・2階とも平日・土日祝11.1円/球
# 出典：https://golf-medley.com/practice_facilities/982
# 掲載情報の更新日：2024年11月21日
# 最新料金は未確認

range = GolfPracticeRange.find_by!(
  name: "河内ゴルフ倶楽部"
)

[ :weekday, :weekend ].each do |day_type|
  [ 1, 2 ].each do |floor|
    price = range.ball_prices.find_or_initialize_by(
      day_type: day_type,
      floor_number: floor,
      start_time: nil,
      end_time: nil
    )

    price.price_per_ball = 11.1
    price.save!
  end
end

# 旭東ゴルフガーデン
# 貸出ボール料金：500円50球、1,000円110球
# 1,000円購入時の単価：約9.09円/球
# 入場料無料
# 出典：現地料金表の写真
# 注意：曜日・時間帯による料金差は未確認

range = GolfPracticeRange.find_by!(
  name: "旭東ゴルフガーデン"
)

[ :weekday, :weekend ].each do |day_type|
  price = range.ball_prices.find_or_initialize_by(
    day_type: day_type,
    floor_number: nil,
    start_time: nil,
    end_time: nil
  )

  price.price_per_ball = (1000.0 / 110).round(2)
  price.save!
end

puts "ボール料金登録件数: #{BallPrice.count}件"
