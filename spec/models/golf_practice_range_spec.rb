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

  describe "#safe_official_website_url" do
    it "HTTPSのURLはそのまま返す" do
      range = build(:golf_practice_range, official_website_url: "https://example.com")

      expect(range.safe_official_website_url).to eq("https://example.com")
    end

    it "HTTPのURLはそのまま返す" do
      range = build(:golf_practice_range, official_website_url: "http://example.com")

      expect(range.safe_official_website_url).to eq("http://example.com")
    end

    it "URLが空の場合はnilを返す" do
      range = build(:golf_practice_range, official_website_url: nil)

      expect(range.safe_official_website_url).to be_nil
    end

    it "HTTP・HTTPS以外のURLはnilを返す" do
      range = build(:golf_practice_range, official_website_url: "javascript:alert(1)")

      expect(range.safe_official_website_url).to be_nil
    end

    it "ホスト名がないURLはnilを返す" do
      range = build(:golf_practice_range, official_website_url: "http:")

      expect(range.safe_official_website_url).to be_nil
    end

    it "不正なURLの場合はnilを返す" do
      range = build(:golf_practice_range, official_website_url: "https://example.com/invalid url")

      expect(range.safe_official_website_url).to be_nil
    end
  end

  describe ".order_by_minimum_price" do
    it "ボール単価が安い順に練習場を取得する" do
      expensive = create(:golf_practice_range, name: "料金が高い練習場")
      cheap = create(:golf_practice_range, name: "料金が安い練習場")

      create(:ball_price, golf_practice_range: expensive, price_per_ball: 12)
      create(:ball_price, golf_practice_range: cheap, price_per_ball: 8)

      ranges = GolfPracticeRange.where(id: [ expensive.id, cheap.id ])
                                .order_by_minimum_price.to_a

      expect(ranges).to eq([ cheap, expensive ])
    end

    it "料金が未登録の練習場を最後に表示する" do
      unknown = create(:golf_practice_range, name: "料金未登録の練習場")
      priced = create(:golf_practice_range, name: "料金登録済みの練習場")

      create(:ball_price, golf_practice_range: priced, price_per_ball: 10)

      ranges = GolfPracticeRange.where(id: [ unknown.id, priced.id ])
                                .order_by_minimum_price.to_a

      expect(ranges).to eq([ priced, unknown ])
    end

    it "最安料金が同額の場合は名前順に並べる" do
      range_b = create(:golf_practice_range, name: "B練習場")
      range_a = create(:golf_practice_range, name: "A練習場")

      create(:ball_price, golf_practice_range: range_b, price_per_ball: 10)
      create(:ball_price, golf_practice_range: range_a, price_per_ball: 10)

      ranges = GolfPracticeRange.where(id: [ range_b.id, range_a.id ])
                                .order_by_minimum_price.to_a

      expect(ranges.map(&:name)).to eq([ "A練習場", "B練習場" ])
    end
  end
end
