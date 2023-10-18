class ChangeColumnReviews < ActiveRecord::Migration[6.1]
  def up
    remove_index :reviews, :todo_id
    add_index :reviews, :todo_id, unique:true
  end

  def down
    add_index :reviews, :todo_id
    remove_index :reviews, :todo_id, unique:true
  end
end
