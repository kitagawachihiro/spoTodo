class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :todo, null: false, foreign_key: true
      t.integer :rating
      t.string :comment
      t.integer :addcount

      t.timestamps
    end
  end
end
