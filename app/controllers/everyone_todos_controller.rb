class EveryoneTodosController < ApplicationController
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

  def add_todo
    #やりたいとされたtodoを取得
    origin_todo = Todo.find(params[:todo_id])
    copy_todo = Todo.new(content: origin_todo.content, spot_id: origin_todo.spot.id, user_id: params[:user_id])

    if copy_todo.save
      origin_todo.increment!(:addcount)
      redirect_to everyonetodos_path, success: 'あなたのTodoに追加しました。ALLで確認できます。'
    else
      redirect_to everyonetodos_path, danger: 'あなたのTodoへ追加できませんでした。'
    end
  end
end
