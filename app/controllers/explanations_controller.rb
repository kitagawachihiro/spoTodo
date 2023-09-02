class ExplanationsController < ApplicationController
    before_action :not_allow_access

    def top;end

    private

    def not_allow_access
        redirect_to todos_path if current_user.present?
    end

end
