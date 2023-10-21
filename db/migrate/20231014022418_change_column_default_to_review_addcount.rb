class ChangeColumnDefaultToReviewAddcount < ActiveRecord::Migration[6.1]
  def change
    change_column_default :reviews, :addcount, from: nil, to: '0'
  end
end
