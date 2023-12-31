class CurrentlocationsController < ApplicationController
    before_action :require_login
  
    def index
      if current_user.currentlocation.nil?
        flash.now[:danger] = t('notice.currentlocation.nil')
        render 'new'
      else
        @q = current_user.spots.ransack(params[:q])
        spots = @q.result.includes(:todos).select(:id, :name).order(id: 'DESC').distinct
        @spots = spots.near_spot(current_user).page(params[:page]).per(10)
        @recommend = Todo.recommend(current_user)   
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
        Currentlocation.create(address: address, latitude: params[:latitude], longitude: params[:longitude], user_id:current_user.id)
      else #どちらもできなかった場合は
        flash[:danger] = t('notice.login.danger')
      end
      redirect_to action: 'index'
    end  
  end