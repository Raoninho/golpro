require "rails_helper"

RSpec.describe "ゴルフ練習場の検索・並び替え", type: :request do
  before do
    host! "localhost"
    GolfPracticeRange.destroy_all
  end
  let!(:higashiosaka) do
    create(
      :golf_practice_range,
      name: "東大阪テスト練習場",
      city: "東大阪市",
      address: "大阪府東大阪市テスト町1-1"
    )
  end

  let!(:yao) do
    create(
      :golf_practice_range,
      name: "八尾テスト練習場",
      city: "八尾市",
      address: "大阪府八尾市テスト町2-2"
    )
  end

  describe "地域検索" do
    it "指定した地域の練習場だけ表示される" do
      get golf_ranges_path, params: { city: "東大阪市" }

      expect(response).to have_http_status(:ok)
      expect(displayed_range_names).to include(higashiosaka.name)
      expect(displayed_range_names).not_to include(yao.name)
    end

    it "地域を指定しない場合はすべて表示される" do
      get golf_ranges_path

      expect(response).to have_http_status(:ok)
      expect(displayed_range_names).to include(higashiosaka.name, yao.name)
    end

    it "検索結果が0件の場合はメッセージを表示する" do
      get golf_ranges_path, params: { city: "存在しない地域" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("該当する地域の練習場はありません")
      expect(displayed_range_names).to be_empty
    end
  end

  def displayed_range_names
    response.parsed_body.css(".grid h2").map { |element| element.text.strip }
  end

  describe "料金の並び替え" do
    it "最安ボール単価が安い順に表示される" do
      higashiosaka.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 12
      )

      yao.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 8
      )

      get golf_ranges_path, params: { sort: "price_asc" }

      expect(response).to have_http_status(:ok)
      expect(displayed_range_names).to eq([ yao.name, higashiosaka.name ])
    end

    it "複数料金がある場合は最安値を基準に並び替える" do
      higashiosaka.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 12
      )

      higashiosaka.ball_prices.create!(
        day_type: :weekend,
        price_per_ball: 7
      )

      yao.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 9
      )

      get golf_ranges_path, params: { sort: "price_asc" }

      expect(response).to have_http_status(:ok)
      expect(displayed_range_names).to eq([ higashiosaka.name, yao.name ])
    end


    it "料金未登録の施設は最後に表示される" do
      yao.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 10
      )

      get golf_ranges_path, params: { sort: "price_asc" }

      expect(response).to have_http_status(:ok)
      expect(displayed_range_names).to eq([ yao.name, higashiosaka.name ])
    end


    it "地域検索と料金順の並び替えを併用できる" do
      another_range = create(
        :golf_practice_range,
        name: "東大阪第二練習場",
        city: "東大阪市",
        address: "大阪府東大阪市テスト町3-3"
      )

      higashiosaka.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 12
      )

      another_range.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 8
      )

      yao.ball_prices.create!(
        day_type: :weekday,
        price_per_ball: 5
      )

      get golf_ranges_path,
          params: { city: "東大阪市", sort: "price_asc" }

      expect(response).to have_http_status(:ok)
      expect(displayed_range_names).to eq(
        [ another_range.name, higashiosaka.name ]
      )
    end
  end


    describe "存在しない練習場へのアクセス" do
    it "404ステータスを返す" do
      get golf_range_path(id: 999999)

      expect(response).to have_http_status(:not_found)
    end
  end
end
