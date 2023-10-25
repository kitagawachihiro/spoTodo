class EveryoneTodosController < ApplicationController
  def index
    @e_todos = Todo.where(public: TRUE).includes(:spot)
  end
end
