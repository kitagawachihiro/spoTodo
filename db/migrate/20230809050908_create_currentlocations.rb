class CreateCurrentlocations < ActiveRecord::Migration[5.2]
  def change
    create_table :currentlocations do |t|
      t.string :address, null:false
      t.float :latitude, null:false
      t.float :longitude, null:false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
