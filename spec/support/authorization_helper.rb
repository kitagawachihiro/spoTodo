module AuthorizationHelper
    def authorization_stub
        allow_any_instance_of(TodosController).to receive(:current_user).and_return(current_user)

        #Userクラスのフリをしているやつに対してcurrent_userが呼ばれたら、
        #定数current_userを返す
        #allow(controller).to receive(:current_user).and_return(mock_user)
    end
  end