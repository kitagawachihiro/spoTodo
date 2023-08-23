class ChangeColumnUserDistance < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :distance, from: 0, to: 0.621371
  end
end
