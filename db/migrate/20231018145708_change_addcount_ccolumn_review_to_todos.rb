class ChangeAddcountCcolumnReviewToTodos < ActiveRecord::Migration[6.1]
  def up
    add_column :todos, :addcount, :integer, default: 0
    remove_column :reviews, :addcount, :integer, default: 0
  end

  def down
    remove_column :reviews, :addcount, :integer, default: 0
    add_column :todos, :addcount, :integer, default: 0
  end
end
