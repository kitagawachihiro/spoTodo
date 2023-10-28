class Spot < ApplicationRecord
    has_many :todos

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
end
