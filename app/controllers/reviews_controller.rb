class ReviewsController < ApplicationController
  before_action :current_todo, only: %i[new create]
  before_action :current_review, only: %i[edit update destroy]
  before_action :require_login

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(rating: params[:rating], comment: params[:comment], todo_id: @todo.id)
    if @review.save
      redirect_to todos_path, success: t('notice.review.create')
    else
      flash.now[:danger] = t('notice.review.not_create')
      render :new
    end
  end

  def edit
    @review = Review.find_by(todo_id: params[:todo_id])
  end

  def update; end

  def destroy
    @review.destroy
    redirect_to todos_path, success: 'レビューを削除しました'
  end

  private

  def current_todo
    @todo = Todo.find_by(id: params[:todo_id])
    redirect_to todos_path unless current_user.todos.include?(@todo)
  end

  def current_review
    @review = Review.find_by(todo_id: params[:todo_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :todo_id)
  end
end
