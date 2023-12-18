class Todo < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_one :review, dependent: :destroy

  validates :content, presence: true
  validates :finished, inclusion: [true, false]
  validates :user_id, presence: true
  validates :spot_id, presence: true

  scope :recommend, lambda { |current_user| 
                      joins(:spot)
                        .where(public: true)
                        .where.not(user_id: current_user.id)
                        .select("todos.*, POW(spots.latitude - #{current_user.currentlocation.latitude}, 2) + POW(spots.longitude - #{current_user.currentlocation.longitude}, 2) AS distance")
                        .order('distance ASC, addcount DESC')
                        .limit(5)
                    }
  
  def self.ransackable_attributes(_auth_object = nil)
    %w[addcount content created_at finished id public spot_id updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[review spot user]
  end
end
