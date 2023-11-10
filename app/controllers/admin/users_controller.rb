module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.all.order(created_at: :desc).page(params[:page])
    end

    def destroy
      @user.destroy!
      redirect_to admin_users_path, success: '削除しました'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
