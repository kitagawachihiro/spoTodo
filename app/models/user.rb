class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :authentication, :dependent => :destroy
  accepts_nested_attributes_for :authentication

  has_many :todos, :dependent => :destroy
  has_many :spots, through: :todos
end
