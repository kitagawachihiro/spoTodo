class EveryoneTodosController < ApplicationController
  before_action :require_login

  def index
    @q = Spot.ransack(params[:q])
    @spots = @q.result(distinct: true)
    @e_todo = []

    @spots.each do |spot|
      spot.todos.each do |todo|
        @e_todo << todo if current_user.todos.exclude?(todo) && todo.public == TRUE
      end
    end

    @e_todo = Kaminari.paginate_array(@e_todo).page(params[:page]).per(10)
  end
  
end
