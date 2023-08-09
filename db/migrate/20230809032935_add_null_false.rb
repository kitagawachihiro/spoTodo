class AddNullFalse < ActiveRecord::Migration[5.2]
  def change
    change_column :todos, :content, :string, null: false
    change_column :todos, :user_id, :integer, null: false
    change_column :todos, :spot_id, :integer, null: false
    change_column :spots, :name, :string, null: false
    change_column :spots, :address, :string, null: false
    change_column :spots, :latitude, :float, null: false
    change_column :spots, :longitude, :float, null: false
  end
end
