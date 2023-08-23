class UsersController < ApplicationController
before_action :require_login

def edit;end

def update
    if current_user.update(distance: params[:distance])
        redirect_to action: :edit
        flash[:success] = '更新しました'
    else
        rendner "edit"
        flash.now[:danger] = '更新できませんでした'
    end
end

end
