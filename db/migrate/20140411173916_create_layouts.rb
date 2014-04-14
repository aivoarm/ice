class CreateLayouts < ActiveRecord::Migration
  def change
    create_table :layouts do |t|
      t.string :description
      t.integer :start
      t.integer :length
      t.string :ftype
      t.string :ou

      t.timestamps
    end
  end
end
