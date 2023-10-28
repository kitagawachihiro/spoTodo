class CurrentlocationsController < ApplicationController
    before_action :require_login
  
    def index
      if current_user.currentlocation.nil?
        flash.now[:danger] = t('notice.currentlocation.nil')
        render 'new'
      else
        @q = current_user.spots.ransack(params[:q])
        spots = @q.result.includes(:todos).select(:id, :name).order(id: 'DESC').distinct
        @spots = spots.near([current_user.currentlocation.latitude, current_user.currentlocation.longitude], current_user.distance).page(params[:page]).per(10)

        @recommend = Todo.joins(:spot)
        .where(public: true)
        .where.not(user_id: current_user.id)
        .select("todos.*, POW(spots.latitude - #{current_user.currentlocation.latitude}, 2) + POW(spots.longitude - #{current_user.currentlocation.longitude}, 2) AS distance")
        .order("distance ASC, addcount DESC")
        .limit(5)

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
  

    def add_todo
      origin_todo = Todo.find(params[:todo_id])
      copy_todo = Todo.new(content: origin_todo.content, spot_id: origin_todo.spot.id, user_id: params[:user_id])
  
      if copy_todo.save
        begin
          origin_todo.increment!(:addcount)
        rescue => e
          Rails.logger.debug e.message
        end
        redirect_to action: 'index', success: 'あなたのTodoに追加しました。ALLで確認できます。'
      else
        redirect_to action: 'index', danger: 'あなたのTodoへ追加できませんでした。'
      end
    end

  end