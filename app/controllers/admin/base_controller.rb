class Admin::BaseController < ApplicationController
    before_action :check_admin
    layout 'admin/layouts/application'
  
  
    private

    def check_admin
      user = User.find(1)
      redirect_to root_path, danger: 'アクセスできません' unless current_user.id == user.id
    end

end
