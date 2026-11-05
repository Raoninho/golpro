require "rails_helper"

RSpec.describe GolfPracticeRange, type: :model do
  describe "バリデーション" do
    it "名前・地域・住所があれば有効である" do
      range = build(:golf_practice_range)

      expect(range).to be_valid
    end

    it "名前がない場合は無効である" do
      range = build(:golf_practice_range, name: nil)

      expect(range).not_to be_valid
    end

    it "地域がない場合は無効である" do
      range = build(:golf_practice_range, city: nil)

      expect(range).not_to be_valid
    end

    it "住所がない場合は無効である" do
      range = build(:golf_practice_range, address: nil)

      expect(range).not_to be_valid
    end
  end

  describe "関連付け" do
    it "複数のボール料金を持てる" do
      range = create(:golf_practice_range)

      range.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 10
      )

      range.ball_prices.create!(
        day_type: :weekend,
        price_per_ball: 12
      )

      expect(range.ball_prices.count).to eq(2)
    end
  end

  describe "#minimum_ball_price" do
    it "複数の料金から最安値を取得できる" do
      range = create(:golf_practice_range)

      range.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 12
      )

      range.ball_prices.create!(
        day_type: :weekend,
        price_per_ball: 9
      )

      expect(range.minimum_ball_price).to eq(9)
    end

    it "料金が登録されていない場合はnilを返す" do
      range = create(:golf_practice_range)

      expect(range.minimum_ball_price).to be_nil
    end
  end
end
