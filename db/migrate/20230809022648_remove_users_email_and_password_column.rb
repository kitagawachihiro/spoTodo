class RemoveUsersEmailAndPasswordColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :email, :string
    remove_column :users, :crypted_password,  :string
    remove_column :users, :salt, :string
  end
end
