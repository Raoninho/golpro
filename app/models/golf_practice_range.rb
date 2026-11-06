class GolfPracticeRange < ApplicationRecord
  validates :name, :city, :address, presence: true

  has_many :ball_prices, dependent: :destroy
  has_one_attached :image


  scope :order_by_minimum_price, lambda {
    select(
      "golf_practice_ranges.*",
      "(SELECT MIN(price_per_ball) FROM ball_prices " \
      "WHERE ball_prices.golf_practice_range_id = golf_practice_ranges.id) AS minimum_price"
    ).order(
      Arel.sql(
        "minimum_price ASC NULLS LAST, " \
        "golf_practice_ranges.name ASC, " \
        "golf_practice_ranges.id ASC"
      )
    )
  }


  def minimum_ball_price
    ball_prices.map(&:price_per_ball).compact.min
  end

  def safe_official_website_url
    url = official_website_url
    return if url.blank?

    uri = URI.parse(url)
    return unless uri.is_a?(URI::HTTP)
    return if uri.host.blank?

    uri.to_s
  rescue URI::InvalidURIError
    nil
  end
end
