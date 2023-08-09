class AddUserColumnDistance < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :distance, :float, default: 0
  end
end
