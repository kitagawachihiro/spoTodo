class CurrentlocationsController < ApplicationController
    before_action :require_login
    # before_action :ensure_correct_user
  
    def index
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

      #すでにcurrentlocationがある場合はupdate
      if current_user.currentlocation.present?
        current_user.currentlocation.update(address: address, latitude: params[:latitude], longitude: params[:longitude])
      elsif current_user.currentlocation.nil?
        current_user.currentlocation.create(address: address, latitude: params[:latitude], longitude: params[:longitude])
      else どちらもできなかった場合は
        flash[:danger] = '現在地を正しく取得できませんでしたので前回の一覧を表示しました'
      end
      redirect_to action: 'index'
    end
  
    #private
  
    #def ensure_correct_user
    #  redirect_to login_path unless current_user == nil
    #end
  
  end