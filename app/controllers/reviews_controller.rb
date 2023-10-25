class ReviewsController < ApplicationController
  before_action :current_todo, only: %i[new create edit update]
  before_action :current_review, only: %i[edit update destroy]
  before_action :require_login

  def new
    if Review.exists?(todo_id: params[:todo_id])
      redirect_back_or_to todos_path, danger: "既にレビューが作成されています。"
    else
      @review = Review.new
    end
  end

  def create
    @review = Review.new(rating: review_params[:rating], comment: review_params[:comment], todo_id: @todo.id)
    if @review.save
      redirect_to todos_path, success: t('notice.review.create')
    else
      flash.now[:danger] = t('notice.review.not_create')
      render :new
    end
  end

  def edit;end

  def update
    if @review.update(rating: review_params[:rating], comment: review_params[:comment])
      redirect_back_or_to achievedtodos_path, success: 'レビューを更新しました'
    else
      flash.now[:danger] = '更新に失敗しました'
      render 'edit'
    end
  end

  def destroy
    if @review.destroy
      redirect_back_or_to achievedtodos_path, success: 'レビューを削除しました'
    else
      flash.now[:danger] = '削除に失敗しました'
      render 'edit'
    end
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
