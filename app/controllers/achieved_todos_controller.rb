class AchievedTodosController < ApplicationController
  def index
    # @a_todos = current_user.todos.where(finished: TRUE).includes(:spot)

    @q = Spot.ransack(params[:q])
    @spots = @q.result(distinct: true)
    @a_todos = []

    @spots.each do |spot|
      spot.todos.each do |todo|
        @a_todos << todo if current_user.todos.include?(todo) && todo.finished == TRUE
      end
    end

    @a_todos = Kaminari.paginate_array(@a_todos).page(params[:page])
  end
end
