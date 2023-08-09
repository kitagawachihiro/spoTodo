class Spot < ApplicationRecord
    has_many :todos

    validates :name, presence: true
    validates :address, presence: true, length: { maximum: 100 }
    validates :latitude, presence: true
    validates :longitude, presence: true

end
