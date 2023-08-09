class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :authentication, :dependent => :destroy
  accepts_nested_attributes_for :authentication

  has_many :todos, :dependent => :destroy
  has_many :spots, through: :todos

  #0=1km, 1=3km, 2=5km, 3=10km
  enum distance: { '0.621371': 0, '1.86411': 1, '3.10686': 2, '6.21371':3 }

end
