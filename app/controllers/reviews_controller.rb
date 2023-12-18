class ReviewsController < ApplicationController
  before_action :current_todo, only: %i[new create edit update]
  before_action :current_review, only: %i[edit update destroy]
  before_action :require_login

  def new
    if Review.exists?(todo_id: params[:todo_id])
      redirect_back fallback_location: todos_path, danger: t('notice.review.already')
    else
      @review = Review.new
    end
  end

  def create
    @review = Review.new(rating: review_params[:rating], comment: review_params[:comment], todo_id: @todo.id)
    if @review.save
      @todo.update(public: review_params[:public])
      redirect_to todos_path(index_type: 'achieved'), success: t('notice.review.create')
    else
      flash.now[:danger] = t('notice.review.not_create')
      render :new
    end
  end

  def edit; end

  def update
    if @review.update(rating: review_params[:rating], comment: review_params[:comment])
      @todo.update(public: review_params[:public])
      redirect_to todos_path(index_type: 'achieved'), success: t('notice.review.update')
    else
      flash.now[:danger] = t('notice.review.not_update')
      render 'edit'
    end
  end

  def destroy
    if @review.destroy
      redirect_to todos_path(index_type: 'achieved'), success: t('notice.review.delete')
    else
      flash.now[:danger] = t('notice.review.not_delete')
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
    params.require(:review).permit(:rating, :comment, :todo_id, :public)
  end
end
