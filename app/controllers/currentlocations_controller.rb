class CurrentlocationsController < ApplicationController
    before_action :require_login
  
    def index
      spots = current_user.spots.includes(:todos).select(:id, :name).distinct
      @spots = spots.near([current_user.currentlocation.latitude, current_user.currentlocation.longitude], current_user.distance)
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