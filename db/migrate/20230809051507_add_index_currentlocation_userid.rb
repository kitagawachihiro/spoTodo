class AddIndexCurrentlocationUserid < ActiveRecord::Migration[5.2]
  def change
    remove_index :currentlocations, :user_id
    add_index :currentlocations, :user_id, unique: true
  end
end
