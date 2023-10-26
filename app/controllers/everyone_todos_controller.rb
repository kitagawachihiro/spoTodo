class EveryoneTodosController < ApplicationController
  def index
    @e_todos = Todo.where(public: TRUE).includes(:spot)
  end

  def add_todo
    #やりたいとされたtodoを取得
    origin_todo = Todo.find(params[:todo_id])
    copy_todo = Todo.new(content: origin_todo.content, spot_id: origin_todo.spot.id, user_id: params[:user_id])

    if copy_todo.save
      redirect_to everyonetodos_path, success: 'あなたのTodoに追加しました。ALLで確認できます。'
    else
      redirect_to everyonetodos_path, danger: 'あなたのTodoへ追加できませんでした。'
    end
  end
end
