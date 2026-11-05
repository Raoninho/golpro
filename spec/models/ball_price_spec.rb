require "rails_helper"

RSpec.describe BallPrice, type: :model do
  describe "バリデーション" do
    it "必要な情報があれば有効である" do
      price = build(:ball_price)

      expect(price).to be_valid
    end

    it "ボール料金が未入力の場合は無効である" do
      price = build(:ball_price, price_per_ball: nil)

      expect(price).not_to be_valid
    end

    it "ボール料金が0円の場合は無効である" do
      price = build(:ball_price, price_per_ball: 0)

      expect(price).not_to be_valid
    end

    it "ボール料金がマイナスの場合は無効である" do
      price = build(:ball_price, price_per_ball: -1)

      expect(price).not_to be_valid
    end
  end

  describe "曜日・階数のバリデーション" do
    it "平日料金を登録できる" do
      price = build(:ball_price, day_type: :weekday)

      expect(price).to be_valid
      expect(price.weekday?).to be true
    end

    it "土日祝料金を登録できる" do
      price = build(:ball_price, day_type: :weekend)

      expect(price).to be_valid
      expect(price.weekend?).to be true
    end

    it "階数が未設定でも有効である" do
      price = build(:ball_price, floor_number: nil)

      expect(price).to be_valid
    end

    it "階数が1以上なら有効である" do
      price = build(:ball_price, floor_number: 2)

      expect(price).to be_valid
    end

    it "階数が0の場合は無効である" do
      price = build(:ball_price, floor_number: 0)

      expect(price).not_to be_valid
    end

    it "階数がマイナスの場合は無効である" do
      price = build(:ball_price, floor_number: -1)

      expect(price).not_to be_valid
    end
  end

  describe "時間帯のバリデーション" do
    it "開始・終了時間が未設定なら終日料金として有効である" do
      price = build(:ball_price, start_time: nil, end_time: nil)

      expect(price).to be_valid
    end

    it "開始・終了時間が正しく設定されていれば有効である" do
      price = build(:ball_price, start_time: "09:00", end_time: "17:00")

      expect(price).to be_valid
    end

    it "開始時間だけ設定されている場合は無効である" do
      price = build(:ball_price, start_time: "09:00", end_time: nil)

      expect(price).not_to be_valid
    end

    it "終了時間だけ設定されている場合は無効である" do
      price = build(:ball_price, start_time: nil, end_time: "17:00")

      expect(price).not_to be_valid
    end

    it "開始時間が終了時間より遅い場合は無効である" do
      price = build(:ball_price, start_time: "18:00", end_time: "09:00")

      expect(price).not_to be_valid
    end

    it "開始時間と終了時間が同じ場合は無効である" do
      price = build(:ball_price, start_time: "09:00", end_time: "09:00")

      expect(price).not_to be_valid
    end
  end

   describe "関連付け" do
    it "ゴルフ練習場に紐づいていれば有効である" do
      price = build(:ball_price)

      expect(price.golf_practice_range).to be_present
      expect(price).to be_valid
    end

    it "ゴルフ練習場が紐づいていなければ無効である" do
      price = build(:ball_price, golf_practice_range: nil)

      expect(price).not_to be_valid
    end
  end
end
