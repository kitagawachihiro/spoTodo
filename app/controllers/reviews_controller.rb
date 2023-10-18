class ReviewsController < ApplicationController
  before_action :current_todo, only:[:new, :create]
  before_action :require_login

  def new; end

  def create
    @review = Review.new(rating: params[:rating], comment: params[:comment], todo_id: @todo.id)
    binding.pry
    if @review.save
      redirect_to todos_path, success: 'いけたよ'
    else
      flash.now[:danger] = 'できませんでした'
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end


  private

  def current_todo
    @todo = Todo.find_by(id: params[:todo_id])
    redirect_to todos_path unless current_user.todos.include?(@todo)
 end

  def review_params
    params.require(:review).permit(:rating, :comment, :todo_id)
  end

end
