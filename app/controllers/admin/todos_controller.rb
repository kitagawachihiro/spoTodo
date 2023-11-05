class Admin::TodosController < Admin::BaseController
    before_action :set_todo, only: %i[edit update destroy]
  
    def index
      @search = Todo.ransack(params[:q])
      @todos = @search.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
    end
  
    
    def edit; end
  
    def update
      if @todo.update(todo_params)
        redirect_to admin_todos_path(@todo), success: t('defaults.message.updated', item: Todo.model_name.human)
      else
        flash.now[:danger] = t('defaults.message.not_updated', item: Todo.model_name.human)
        render :edit
      end
    end
  
    def destroy
      @todo.destroy!
      redirect_to admin_todos_path, success: t('defaults.message.deleted', item: Todo.model_name.human)
    end
  
    private
  
    def set_todo
      @todo = Todo.find(params[:id])
    end
  
    def todo_params
      params.require(:todo).permit(:content, :finished, :public, :add_count)
    end
  end