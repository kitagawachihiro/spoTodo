class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      redirect_back_or_to todos_path, notice: "LINEでログインしました"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_back_or_to todos_path, notice: "LINEでログインしました"
      rescue StandardError
        redirect_to todos_path, alert: "LINEでのログインに失敗しました"
      end
    end
  end

  def destroy
    logout
    redirect_to login_path
    flash[:success] = "ログアウトしました"
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end
end
