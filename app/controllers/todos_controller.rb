class TodosController < ApplicationController
 before_action :current_todo, only:[:edit, :update, :finish, :continue]
 before_action :ensure_correct_user, only:[:edit, :update, :finish, :continue]
 before_action :require_login


 def index
   @spots = current_user.spots.includes(:todos).select(:id, :name).distinct
 end

 def new
   @todo = Todo.new
 end
 
 def create
   Todo.transaction do
     current_user = User.find(todo_params[:current_user_id])

     if current_user.spots.find_by(address: todo_params[:address]).present?
       @spot = current_user.spots.find_by(address: todo_params[:address])
     else
       @spot = Spot.new(name: todo_params[:name], address: todo_params[:address], latitude: todo_params[:latitude], longitude: todo_params[:longitude])
       @spot.save!
     end
     @todo = current_user.todos.new(content: todo_params[:content], spot_id: @spot.id)
     @todo.save!
   end
   redirect_to todos_path, success: 'todoを作成しました'

   rescue => e #eはerrorのe error情報が格納される変数
     flash.now[:danger] = 'todoを作成できませんでしたよ'
     @todo = Todo.new(todo_params)
     render :new
 
 end

 def edit; end

 def update
 end

 def finish
   @todo= Todo.find(params[:id])
   @todo.update_attributes(finished:true)

   #現在のユーザーでお気に入りを作成
   respond_to do |format|
       format.html { redirect_to root_path }
       format.js { render 'checks/finished.js.erb' }
   end
 end

 def continue
   @todo= Todo.find(params[:id])
   @todo.update_attributes(finished:false)

   #現在のユーザーでお気に入りを作成
   respond_to do |format|
       format.html { redirect_to root_path }
       format.js { render 'checks/continue.js.erb' }
   end
 end

 
 private

 def current_todo
    @todo = Todo.find(params[:id])
 end

 def todo_params
   params.require(:todo).permit(:content, :address, :name, :latitude, :longitude, :current_user_id)
 end
 
 def ensure_correct_user
    redirect_to login_path unless current_user.todos.include?(@todo)
 end
end
