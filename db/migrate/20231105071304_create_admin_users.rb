class CreateAdminUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_users do |t|
      t.string :email
      t.string :password
      t.integer :role

      t.timestamps
    end
  end
end
