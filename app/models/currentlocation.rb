class Currentlocation < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :address, presence: true, length: { maximum: 100 }
  validates :latitude, presence: true
  validates :longitude, presence: true

end
