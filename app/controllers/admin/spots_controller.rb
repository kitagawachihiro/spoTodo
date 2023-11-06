class Admin::SpotsController < Admin::BaseController
  before_action :set_spot, only: %i[edit update destroy]

  def index
    @search = Spot.ransack(params[:q])
    @spots = @search.result(distinct: true).includes(:todos).order(created_at: :desc).page(params[:page])
  end

  def destroy
    @spot.destroy!
    redirect_to admin_spots_path, success: 'Spotを削除しました'
  end

  private

  def set_spot
    @spot = Spot.find(params[:id])
  end
end
