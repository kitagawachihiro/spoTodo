class AchievedTodosController < ApplicationController
  def index
    @a_todos = current_user.todos.where(finished: TRUE).includes(:spot)
  end
end
