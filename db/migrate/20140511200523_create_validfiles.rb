class CreateValidfiles < ActiveRecord::Migration
  def change
    create_table :validfiles do |t|
      t.string :filepath
      t.string :user
      t.string :size
      t.string :ftype
      t.boolean :valid

      t.timestamps
    end
  end
end
