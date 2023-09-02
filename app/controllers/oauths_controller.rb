class OauthsController < ApplicationController
  before_action :not_allow_access, only: [:login]

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      redirect_back_or_to todos_path, success: t('notice.login.success')
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_back_or_to todos_path, success: t('notice.login.success')
      rescue StandardError
        redirect_to login_path, alert: t('notice.login.fail')
      end
    end
  end

  def destroy
    logout
    redirect_to login_path
    flash[:success] = t('notice.login.logout')
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end


  def not_allow_access
    redirect_to todos_path if current_user.present?
  end

end
