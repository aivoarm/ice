class CreateFiletypes < ActiveRecord::Migration
  def change
    create_table :filetypes do |t|
      t.string :ftype
      t.string :country

      t.timestamps
    end
  end
end
