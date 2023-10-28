class Todo < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_one :review, dependent: :destroy

  validates :content, presence: true
  validates :finished, inclusion: [true, false]
  validates :user_id, presence: true
  validates :spot_id, presence: true
  
end
