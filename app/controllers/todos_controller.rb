class TodosController < ApplicationController
 before_action :current_todo, only:[:edit, :update, :finish, :continue, :destroy]
 before_action :ensure_correct_user, only:[:edit, :update, :finish, :continue]
 before_action :require_login


 def index
   @spots = current_user.spots.includes(:todos).select(:id, :name).distinct
 end

 def new
   @todo = Todo.new
 end
 
 def create  
  current_user = User.find(todo_params[:current_user_id])

  if current_user.spots.find_by(address: todo_params[:address]).present?
      @spot = current_user.spots.find_by(address: todo_params[:address])
  else
      @spot = Spot.new(name: todo_params[:name], address: todo_params[:address], latitude: todo_params[:latitude], longitude: todo_params[:longitude])
  end

  if @spot.save
    @todo = current_user.todos.new(content: todo_params[:content], spot_id: @spot.id)
    @todo.save
    redirect_to todos_path, success: 'todoを作成しました'
  else
    @todo = Todo.new(content:todo_params[:content])
    flash.now[:danger] = 'todoを作成できませんでしたよ'
    render :new
  end

 end

 def edit;end

 def update
    current_user = User.find(todo_params[:current_user_id])

    if current_user.spots.find_by(address: todo_params[:address]).present?
        @new_spot = current_user.spots.find_by(address: todo_params[:address])
    else
        @new_spot = Spot.new(name: todo_params[:name], address: todo_params[:address], latitude: todo_params[:latitude], longitude: todo_params[:longitude])
    end

    #もし@spot.addressと@new_spotが違ったら新しいspotを生成する。
    if @spot != @new_spot
      begin
        ActiveRecord::Base.transaction {
          @new_spot.save!
          @todo.update!(content: todo_params[:content], spot_id: @new_spot.id)

          #紐づくtodoが0になってしまったspotは削除する
          @spot.destroy if @spot.todos.empty?
          
          redirect_to todos_path, success: 'todoを更新しました'
        }
      rescue Exception => e
        flash.now[:danger] = 'todoを更新できませんでした'
        render :edit
      end
    else
      if @todo.update!(content: todo_params[:content])
        redirect_to todos_path, success: 'todoを更新しました'
      else
        flash.now[:danger] = 'todoを更新できませんでした'
        render :edit
      end
    end
  end

 def destroy
  @todo.destroy
  flash[:success] = "Article deleted"

#もし紐づくtodoがなくなってしまった場合は、そのspotも削除する
  @todo.spot.destroy if @todo.spot.todos.nil?
  redirect_to todos_url
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
    @todo = current_user.todos.find(params[:id])
    @spot = @todo.spot
 end

 def todo_params
   params.require(:todo).permit(:content, :address, :name, :latitude, :longitude, :current_user_id)
 end
 
 def ensure_correct_user
    redirect_to login_path unless current_user.todos.include?(@todo)
 end
end
