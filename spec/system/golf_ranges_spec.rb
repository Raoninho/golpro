require "rails_helper"

RSpec.describe "ゴルフ練習場の画面操作", type: :system do
  before do
    GolfPracticeRange.destroy_all
  end

  it "練習場一覧ページが表示される" do
    range = create(
      :golf_practice_range,
      name: "東大阪テスト練習場",
      city: "東大阪市"
    )

    visit golf_ranges_path

    expect(page).to have_content(range.name)
  end

  it "一覧ページから練習場の詳細ページへ移動できる" do
    range = create(
      :golf_practice_range,
      name: "東大阪テスト練習場",
      city: "東大阪市"
    )

    visit golf_ranges_path

    click_link range.name

    expect(page).to have_current_path(golf_range_path(range))
    expect(page).to have_css("h1", text: range.name)
  end

  it "地域を選択して検索できる" do
    higashiosaka = create(
      :golf_practice_range,
      name: "東大阪テスト練習場",
      city: "東大阪市"
    )

    yao = create(
      :golf_practice_range,
      name: "八尾テスト練習場",
      city: "八尾市"
    )

    visit golf_ranges_path

    select "東大阪市", from: "地域を選択"
    click_button "検索"

    expect(page).to have_content(higashiosaka.name)
    expect(page).not_to have_content(yao.name)
  end

  it "ボール料金が安い順に並び替えられる" do
    higashiosaka = create(
      :golf_practice_range,
      name: "東大阪テスト練習場",
      city: "東大阪市"
    )

    yao = create(
      :golf_practice_range,
      name: "八尾テスト練習場",
      city: "八尾市"
    )

    create(
      :ball_price,
      golf_practice_range: higashiosaka,
      day_type: :weekday,
      price_per_ball: 12
    )

    create(
      :ball_price,
      golf_practice_range: yao,
      day_type: :weekday,
      price_per_ball: 8
    )

    visit golf_ranges_path

    select "ボール単価が安い順", from: "並び替え"
    click_button "検索"

    displayed_names = page.all(".grid h2").map { |element| element.text.strip }

    expect(displayed_names).to eq([ yao.name, higashiosaka.name ])
  end


  it "料金未登録の練習場には情報なしと表示される" do
    range = create(
      :golf_practice_range,
      name: "料金未登録テスト練習場",
      city: "東大阪市"
    )

    visit golf_ranges_path

    expect(page).to have_content(range.name)
    expect(page).to have_content("最安ボール単価")
    expect(page).to have_content("情報なし")
  end


  it "詳細ページに公式サイトへのリンクが表示される" do
    range = create(
      :golf_practice_range,
      name: "東大阪テスト練習場",
      city: "東大阪市",
      official_website_url: "https://example.com/golf"
    )

    visit golf_range_path(range)

    expect(page).to have_css(
      "a[href='https://example.com/golf']",
      text: "公式サイトを見る"
    )
  end
end
