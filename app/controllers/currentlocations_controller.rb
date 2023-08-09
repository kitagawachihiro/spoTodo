class CurrentlocationsController < ApplicationController
    before_action :require_login, only:[:index]
    before_action :ensure_correct_user, only:[:index]
  
    def index
      #現在のユーザーの現在地で検索する必要がある
      #paramsで送られてきたuser_idをでcurrent_userをセットする
      #current_user = User.find(params[:user_id]) if params[:user_id].present?
      spotlist = Spot.near([current_user.currentlocation.latitude, current_user.currentlocation.longitude], current_user.distance)
  
  
      
      #spotolistのidで順にtodoの検索をかけ、取得する
      @todolist = []
      spotlist.each do |s|
        todo = Todo.where(spot_id: s.id).includes(:spot)
        todo.each do |t|
          @todolist << t
        end
      end
    end
  
    def new; end
  
    def create
  
      results = Geocoder.search([params[:latitude], params[:longitude]])
      address = results.first.address
      currentlocation = current_user.currentlocation.new(address: address, latitude: params[:latitude], longitude: params[:longitude])
      #currentlocation = Currentlocation.new(address: address, latitude: params[:latitude], longitude: params[:longitude], user_id: 1)
      
      if currentlocation.save
        redirect_to root_path
      else
        flash[:danger] = '現在地を正しく取得できませんでしたので前回の一覧を表示しました'
        redirect_to root_path
      end
    end
  
    private
  
    def ensure_correct_user
      user = User.find(params[:user_id])
      redirect_to login_path unless current_user == user
    end
  
  end