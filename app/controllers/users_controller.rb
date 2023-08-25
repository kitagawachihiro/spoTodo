class UsersController < ApplicationController
before_action :require_login

def edit;end

def update
    if current_user.update(distance: params[:distance])
        redirect_to action: :edit
        flash[:success] = t('notice.user.update')
    else
        rendner "edit"
        flash.now[:danger] = t('notice.user.not_update')
    end
end

end
