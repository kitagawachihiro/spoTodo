class ApplicationController < ActionController::Base
    add_flash_types :success, :danger

    protected
    # 外部から隠蔽したい,レシーバーを仲間が利用するメソッド

    def not_authenticated
      redirect_to login_path, alert: 'ログインしてください'
    end
end
