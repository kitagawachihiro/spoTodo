class AddCcolumnTodosPublic < ActiveRecord::Migration[6.1]
  def up
    add_column :todos, :public, :boolean, default: false, null: false
  end

  def down
    remove_column :todos, :public, :boolean, default: false, null: false
  end
end
