class TodosController < ApplicationController
 before_action :current_todo, only:[:edit, :update, :finish, :continue, :destroy]
 before_action :require_login

 def index
  @q = current_user.spots.ransack(params[:q])
  @spots = @q.result(distinct: true).includes(:todos).select(:id, :name).order(id: :desc).page(params[:page]).per(20)
 end

 def new
   @todo_spot = TodoSpot.new(current_user, Todo.new)
 end
 
 def create
  if params[:original_location].nil?
    @todo_spot = TodoSpot.new(current_user, todo_spot_params, Todo.new)

    if @todo_spot.save(todo_spot_params)
      redirect_to todos_path, success: t('notice.todo.create')
    else
      flash.now[:danger] = t('notice.todo.not_create')
      render :new
    end
  else
    result = AddMyTodo.call(params)
    if result[:success]
      if params[:original_location] = 'current_location'
        redirect_to currentlocations_path, success: result[:success]
      else
        redirect_to everyonetodos_path, success: result[:success]
      end 
    else
      if params[:original_location] = 'current_location'
        redirect_to currentlocations_path, danger: result[:danger]
      else
        redirect_to everyonetodos_path, danger: result[:danger]
      end
    end
  end

 end

 def edit
  @todo_spot = TodoSpot.new(current_user, @todo)
 end

 def update
  @todo_spot = TodoSpot.new(current_user, todo_spot_params, @todo)
  if @todo_spot.update(todo_spot_params)
    redirect_to todos_path, success: t('notice.todo.update')
  else
    flash.now[:danger] = t('notice.todo.not_update')
    render :edit
  end


  def finish
    @todo= Todo.find(params[:id])
    @todo.update(finished:true)
      #todoをチェック
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render 'checks/finished.js.erb' }
    end
   end
  
   def continue
     @todo= Todo.find(params[:id])
     @todo.update(finished:false)
  
     #todoからチェックを外す
     respond_to do |format|
         format.html { redirect_to root_path }
         format.js { render 'checks/continue.js.erb' }
     end
   end



 end

 def destroy
  @todo.destroy
  flash[:success] = t('notice.todo.destroy')
  destroy_empty_spot
 end

 

 private

 def current_todo
    @todo = Todo.find_by(id: params[:id])
    if current_user.todos.include?(@todo)
      @spot = @todo.spot
    else
      redirect_to login_path
    end
 end

 def todo_spot_params
  params.require(:todo_spot).permit(:content, :user_id, :public, :name, :address, :latitude, :longitude)
 end
 
 def destroy_empty_spot
   #もし紐づくtodoがなくなってしまった場合は、そのspotも削除する
   @spot.destroy if @spot.todos.empty?
   redirect_back(fallback_location: todos_url)
   true
 end
end
