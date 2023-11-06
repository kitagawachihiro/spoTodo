class Todo < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_one :review, dependent: :destroy

  validates :content, presence: true
  validates :finished, inclusion: [true, false]
  validates :user_id, presence: true
  validates :spot_id, presence: true
  
  def self.ransackable_attributes(auth_object = nil)
    ["addcount", "content", "created_at", "finished", "id", "public", "spot_id", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["review", "spot", "user"]
  end
end
