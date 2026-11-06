
class GolfRangesController < ApplicationController
  def index
    @golf_ranges = GolfPracticeRange
                   .includes(:ball_prices)
                   .with_attached_image

    # 地域検索
    if params[:city].present?
      @golf_ranges = @golf_ranges.where(city: params[:city])
    end

    # 並び替え
    if params[:sort] == "price_asc"
      @golf_ranges = @golf_ranges.order_by_minimum_price
    else
      @golf_ranges = @golf_ranges.order(:name, :id)
    end
  end

  def show
    @golf_range = GolfPracticeRange
                  .includes(:ball_prices)
                  .find(params[:id])
  end
end
