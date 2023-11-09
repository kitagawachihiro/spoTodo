class Spot < ApplicationRecord
    has_many :todos, dependent: :destroy

    #geocodeを使用するカラム
    #このアプリではlatitude, longitudeを使用して、addressを取得している
    #本来はアドレス→緯度経度なのでreverse
    reverse_geocoded_by :latitude, :longitude

    validates :name, presence: true
    validates :address, presence: true, length: { maximum: 100 }
    validates :latitude, presence: true
    validates :longitude, presence: true

    def self.ransackable_attributes(_auth_object = nil)
        ['name']
    end
    
    #spotがない場合、spotを作成する
    def self.create_spot(todo_params)
        if self.find_by(address: todo_params[:address]).present?
            @spot = self.find_by(address: todo_params[:address])
          else
            @spot = self.new(name: todo_params[:name], address: todo_params[:address], latitude: todo_params[:latitude], longitude: todo_params[:longitude])
          end
    end

    #編集後のスポットのセットを行う
    def self.setting_new_spot(todo_params)
        if self.find_by(address: todo_params[:address]).present?
            self.find_by(address: todo_params[:address])
        else
            self.new(name: todo_params[:name], address: todo_params[:address], latitude: todo_params[:latitude], longitude: todo_params[:longitude])
        end
    end
end
