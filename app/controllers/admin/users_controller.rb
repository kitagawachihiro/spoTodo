class Admin::UsersController < Admin::BaseController
    before_action :set_user, only: %i[show edit update destroy]
  
    def index
      @search = User.ransack(params[:q])
      @users = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
    end
  
    def destroy
      @user.destroy!
      redirect_to admin_users_path, success: t('defaults.message.deleted', item: User.model_name.human)
    end
  
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
  end