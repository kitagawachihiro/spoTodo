class AddMyTodo
  include Service

  def initialize(params)
    @origin_todo = Todo.find(params[:todo_id])
    @user_id = params[:user_id]
    @original_location = params[:original_location]
  end

  def call
    copy_todo = Todo.new(content: @origin_todo.content, spot_id: @origin_todo.spot.id, user_id: @user_id)

    return { danger: 'あなたのTodoへ追加できませんでした。' } unless copy_todo.save

    begin
      origin_todo.increment!(:addcount)
    rescue StandardError => e
      Rails.logger.debug e.message
    end
    { success: 'あなたのTodoに追加しました。MyTodoで確認できます。' }
  end
end
