class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :admin_users, :role, :integer, default: 0, null: false
  end
end
