class Review < ApplicationRecord
  belongs_to :todo

  validates :todo_id, uniqueness: true
end
