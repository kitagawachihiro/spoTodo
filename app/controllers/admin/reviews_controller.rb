class Admin::ReviewsController < Admin::BaseController
  before_action :set_review, only: %i[edit update destroy]

  def index
    @reviews = Review.all.distinct(:true).includes(:todo).order(created_at: :desc).page(params[:page])
  end

  def destroy
    @review.destroy
    redirect_to admin_reviews_path, success: 'Reviewを削除しました'
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content, :finished, :public, :add_count)
  end
end
